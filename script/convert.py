#!/usr/bin/env python3

#  ~/scripts/convert_new.py --fps 15 -n 20   -d 6 --gpu /Users/chenyang/Documents/Design\ Principles  ~/Downloads/output/

import argparse
import os
from pathlib import Path
import subprocess
import shutil
from tqdm import tqdm
import cv2
import numpy as np
from PIL import Image
import torch
import platform
import textwrap
import stat
from concurrent.futures import ThreadPoolExecutor
import multiprocessing

def sanitize_path(path):
    """Convert path to string and escape spaces."""
    return str(path).replace(" ", "\\ ")


def is_animated_gif(path):
    """Check if a GIF file is animated."""
    try:
        with Image.open(path) as img:
            try:
                img.seek(1)
                return True
            except EOFError:
                return False
    except Exception:
        return False

def get_optimal_codec(file_size, use_gpu):
    """Determine the most efficient codec based on file size and platform."""
    if platform.processor() == 'arm':  # M1/M2 chips
        if use_gpu:
            return 'h264_videotoolbox'  # VideoToolbox H.264 for Apple Silicon
    return 'libx264'  # Default to H.264 for maximum compatibility

def create_looped_video(input_path, output_path, duration_minutes, use_gpu, fps):
    """Create an efficiently looped MP4 from a GIF with QuickTime compatibility."""
    try:
        gif = Image.open(input_path)
        frames = []
        try:
            while True:
                frame = gif.convert('RGB')
                original_width, original_height = frame.size
                aspect_ratio = original_width / original_height
                new_height = 1080  # Changed to 1080p
                new_width = int(new_height * aspect_ratio)
                frame = frame.resize((new_width, new_height), Image.LANCZOS)
                frames.append(np.array(frame))
                gif.seek(gif.tell() + 1)
        except EOFError:
            pass

        if not frames:
            raise Exception("No frames could be extracted from the GIF")

        frame_count = len(frames)
        original_duration = frame_count / fps
        height, width = frames[0].shape[:2]
        codec = get_optimal_codec(os.path.getsize(input_path), use_gpu)

        input_options = []
        output_options = [
            '-c:v', codec,
            '-profile:v', 'high',
            '-pix_fmt', 'yuv420p',
            '-movflags', '+faststart',
            '-b:v', '8M'  # Increased bitrate for 1080p
        ]

        if use_gpu and platform.processor() == 'arm':
            input_options.extend([
                '-hwaccel', 'videotoolbox'
            ])
            output_options.extend([
                '-preset', 'fast'
            ])
        else:
            output_options.extend(['-preset', 'medium'])

        temp_output = str(output_path.parent / f"temp_{output_path.stem}.mp4")

        command = [
            'ffmpeg', '-y'
        ] + input_options + [
            '-f', 'rawvideo',
            '-vcodec', 'rawvideo',
            '-s', f'{width}x{height}',
            '-pix_fmt', 'rgb24',
            '-r', str(fps),
            '-i', '-'
        ] + output_options + [temp_output]

        process = subprocess.Popen(command,
                                 stdin=subprocess.PIPE,
                                 stderr=subprocess.PIPE,
                                 bufsize=10*1024*1024)

        chunk_size = 1024*1024
        for frame in frames:
            frame_bytes = frame.tobytes()
            for i in range(0, len(frame_bytes), chunk_size):
                chunk = frame_bytes[i:i + chunk_size]
                try:
                    process.stdin.write(chunk)
                except BrokenPipeError:
                    stderr = process.stderr.read()
                    raise Exception(f"Broken pipe while writing frames: {stderr.decode()}")

        process.stdin.close()
        stderr = process.stderr.read()
        process.stderr.close()
        return_code = process.wait()

        if return_code != 0:
            raise Exception(f"FFmpeg encoding failed: {stderr.decode()}")

        loop_count = int(np.ceil(duration_minutes * 60 / original_duration))

        final_command = [
            'ffmpeg', '-y'
        ] + input_options + [
            '-stream_loop', str(loop_count),
            '-i', temp_output,
            '-t', str(duration_minutes * 60)
        ] + output_options + [str(output_path)]

        result = subprocess.run(final_command, capture_output=True, text=True)
        if result.returncode != 0:
            raise Exception(f"FFmpeg looping failed: {result.stderr}")

        if os.path.exists(temp_output):
            os.remove(temp_output)

    except Exception as e:
        if os.path.exists(temp_output):
            try:
                os.remove(temp_output)
            except:
                pass
        raise Exception(f"Error in create_looped_video: {str(e)}")

def create_static_video(input_path, output_path, duration_minutes, use_gpu, fps):
    """Create a video from a static image."""
    temp_path = None
    temp_video = None

    try:
        temp_path = str(input_path.parent / f"temp_{input_path.stem}.png")
        temp_video = str(input_path.parent / f"temp_{input_path.stem}.mp4")

        with Image.open(input_path) as img:
            img = img.convert('RGB')
            original_width, original_height = img.size
            aspect_ratio = original_width / original_height
            new_height = 1080  # Changed to 1080p
            new_width = int(new_height * aspect_ratio)
            img = img.resize((new_width, new_height), Image.LANCZOS)
            img.save(temp_path)

        codec = get_optimal_codec(os.path.getsize(temp_path), use_gpu)

        input_options = []
        output_options = [
            '-c:v', codec,
            '-profile:v', 'high',
            '-pix_fmt', 'yuv420p',
            '-movflags', '+faststart',
            '-b:v', '8M'  # Increased bitrate for 1080p
        ]

        if use_gpu and platform.processor() == 'arm':
            input_options.extend([
                '-hwaccel', 'videotoolbox'
            ])
            output_options.extend([
                '-preset', 'fast'
            ])
        else:
            output_options.extend(['-preset', 'medium'])

        initial_command = [
            'ffmpeg', '-y'
        ] + input_options + [
            '-loop', '1',
            '-r', str(fps),
            '-i', temp_path,
            '-t', '1'
        ] + output_options + [temp_video]

        result = subprocess.run(initial_command,
                              capture_output=True,
                              text=True,
                              check=True)

        final_command = [
            'ffmpeg', '-y'
        ] + input_options + [
            '-stream_loop', '-1',
            '-i', temp_video,
            '-t', str(duration_minutes * 60)
        ] + output_options + [str(output_path)]

        result = subprocess.run(final_command,
                              capture_output=True,
                              text=True,
                              check=True)

    except subprocess.CalledProcessError as e:
        raise Exception(f"FFmpeg error: {e.stderr}")
    except Exception as e:
        raise Exception(f"Error in create_static_video: {str(e)}")
    finally:
        for temp_file in [temp_path, temp_video]:
            if temp_file and os.path.exists(temp_file):
                try:
                    os.remove(temp_file)
                except Exception as e:
                    print(f"Warning: Could not remove temporary file {temp_file}: {str(e)}")

def check_gpu_availability():
    """Check if GPU acceleration is available and appropriate for the system."""
    if platform.processor() == 'arm':
        try:
            result = subprocess.run(['ffmpeg', '-hwaccels'],
                                 capture_output=True, text=True)
            return 'videotoolbox' in result.stdout.lower()
        except subprocess.CalledProcessError:
            return False
    return False

def process_file(args):
    """Process a single file with the given arguments."""
    input_file, output_dir, duration, use_gpu, fps = args
    try:
        # Create output filename, replacing spaces with underscores
        safe_filename = input_file.stem.replace(' ', '_')
        output_file = output_dir / f"{safe_filename}.mp4"

        if input_file.suffix.lower() == '.gif' and is_animated_gif(input_file):
            create_looped_video(input_file, output_file, duration, use_gpu, fps)
        else:
            create_static_video(input_file, output_file, duration, use_gpu, fps)
        return True
    except Exception as e:
        print(f"\nError converting {input_file}: {str(e)}")
        return False

def main():
    parser = argparse.ArgumentParser(
        description='Convert static images and GIFs to looped MP4s compatible with QuickTime',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=textwrap.dedent('''
            Examples:
                # Convert files with 5-minute duration using 4 concurrent processes:
                %(prog)s input_folder output_folder -d 5 -n 4

                # Use GPU acceleration with maximum concurrency:
                %(prog)s input_folder output_folder -d 5 -n 8 --gpu

            Notes:
                - Supports both static images (jpg, png, etc.) and GIFs
                - Requires FFmpeg to be installed
                - GPU acceleration is only available on Apple Silicon (M1/M2) chips
                - Output videos are optimized for QuickTime playback
                - Progress bar shows conversion status
                - Output resolution is set to 720p
        '''))

    parser.add_argument('input_dir', type=str,
                        help='Input directory containing image files')
    parser.add_argument('output_dir', type=str,
                        help='Output directory for MP4 files')
    parser.add_argument('--duration', '-d', type=float, required=True,
                        help='Duration in minutes for the output videos')
    parser.add_argument('--gpu', action='store_true',
                        help='Enable GPU acceleration (Apple Silicon only)')
    parser.add_argument('--fps', '-f', type=int, default=30,
                        help='Frames per second for the output video (default: 30)')
    parser.add_argument('--num', '-n', type=int, default=multiprocessing.cpu_count(),
                        help='Number of concurrent files to process (default: number of CPU cores)')

    args = parser.parse_args()

    input_dir = Path(args.input_dir).resolve()
    output_dir = Path(args.output_dir).resolve()
    output_dir.mkdir(parents=True, exist_ok=True)

    supported_formats = ('.gif', '.jpg', '.jpeg', '.png', '.bmp')
    input_files = sorted([f for f in input_dir.iterdir()
                          if f.suffix.lower() in supported_formats])

    if not input_files:
        print("No supported image files found in the input directory")
        return

    if args.gpu:
        if check_gpu_availability():
            print("GPU acceleration enabled (using VideoToolbox)")
        else:
            if platform.processor() == 'arm':
                print("Warning: GPU acceleration requested but VideoToolbox not available")
            else:
                print("Warning: GPU acceleration is only available on Apple Silicon chips")
            args.gpu = False

    # Create a list of arguments for each file
    process_args = [(f, output_dir, args.duration, args.gpu, args.fps)
                   for f in input_files]

    # Process files concurrently using ThreadPoolExecutor
    with ThreadPoolExecutor(max_workers=args.num) as executor:
        list(tqdm(executor.map(process_file, process_args),
                 total=len(input_files),
                 desc="Converting files"))

if __name__ == "__main__":
    script_path = Path(__file__).resolve()
    if not os.access(script_path, os.X_OK):
        make_executable(script_path)
    main()
