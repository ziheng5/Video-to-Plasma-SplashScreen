#!/usr/bin/env bash
# Program:
#     Convert your mp4 file to KDE Plasma splash screen
# 2025-12-07    Coldrain    Release 1.0.0
# Advanced Thoughts:
#     Need to add backup part to this script

# 1. Error process
set -euo pipefail                                                           # Exit the process when error occurs
trap 'ec=$?; echo "ERROR: exit=$ec at line $LINENO: $BASH_COMMAND" >&2' ERR # Display the information of error

# 2. Create the template
read -p "Step[1/7]: Please enter your 'author_name': " author_name
read -p "Step[2/7]: Please enter your 'work_name': " work_name
new_name="$author_name.$work_name"

template_path="./template/"
target_path="$HOME/.local/share/plasma/look-and-feel"

mkdir -p "$target_path"

cp -r "$template_path" "$target_path/$new_name"

# 3. Process the video
while true; do
    echo "Step[3/7]: Please enter your mp4 video path (enter 'exit' to exit): "
    read video_path

    if [[ "$video_path" == "exit" ]]; then
        echo "OK, exit now."
        rm -r "$target_path/$new_name"
        exit 0
    fi

    # ensure the file exits
    if [[ -f "$video_path" ]]; then
        echo ">> 🐱 Nya~ Video founded!"
        break
    else
        echo "Oh, the path you enter does not exist, please enter an effective path!"
    fi
done

echo "Step[4/7]: Please enter the period of your video as the splash screen (Format: 'hh:mm:ss~hh:mm:ss', less than 5 seconds recommanded):"
read time_range

begin_time=$(echo $time_range | cut -d'~' -f1)
end_time=$(echo $time_range | cut -d'~' -f2)

echo "Step[5/7]: Please enter the FPS of your splash screen you want (Format: 'fps', 30~120 recommanded): "
read fps
echo "Step[6/7]: Please enter the scale of your splash screen (Format: 'width_scale', 1920 recommanded):"
read scale_width

ffmpeg -ss "$begin_time" -i "$video_path" -to "$end_time" -c:v libx264 -c:a aac -strict experimental -loglevel quiet -hide_banner -y tmp_video.mp4
echo ">> Creating the palette..."
ffmpeg -i ./tmp_video.mp4 -vf "fps=$fps, scale=$scale_width:-2:flags=lanczos,palettegen" -loglevel quiet -hide_banner -y ./palette.png
echo ">> Creating the gif...(Just wait a moment, it depends on the period you entered in Step4)"
ffmpeg -i ./tmp_video.mp4 -ss "$begin_time" -to "$end_time" -i ./palette.png -lavfi "fps=$fps,scale=$scale_width:-2:flags=lanczos[x];[x][1:v]paletteuse" -loglevel quiet -hide_banner -y "$target_path/$new_name/contents/splash/images/$work_name.gif"

rm ./tmp_video.mp4
rm ./palette.png

while true; do
    echo "Step[7/7]: Enter a png picture path as your work's previews image. (enter 'skip' to skip)"
    read picture_path

    if [[ "$picture_path" == "skip" ]]; then
        echo ">> 🐱 Nya~ Skip now. If you want to add a previews image to your work, put your picture under: ~/.local/share/plasma/look-and-feel/your_work/contents/previews/splash.png (Take care! The name of your previous image must be 'splash.png'!)"
        break
    else
        if [[ -f "$picture_path" ]]; then
            cp "$picture_path" "$target_path/$new_name/contents/previews/splash.png"
            echo ">> 🐱 Nya~ Previews image configured!"
            break
        else
            echo ">> Oh, image not found!"
        fi
    fi
done

sed -i "s/\"Id\": \".*\"/\"Id\": \"$new_name\"/" "$target_path/$new_name/metadata.json"
sed -i "s/\"Description\": \".*\"/\"Description\": \"$work_name\"/" "$target_path/$new_name/metadata.json"

jq --arg author_name "$author_name" --arg plugin_name "$work_name" \
    '.Authors[0].Name = $author_name | .KPlugin.Name = $plugin_name' \
    "$target_path/$new_name/metadata.json" >./tmp.json && mv ./tmp.json "$target_path/$new_name/metadata.json"

sed -i "s/gif_file_here/$work_name/" "$target_path/$new_name/contents/splash/Splash.qml"

# 检查操作是否成功
if [ $? -eq 0 ]; then
    echo ">> 🐱 Nya~ Your work has been created here: '$target_path/$new_name'"
else
    echo "Something went wrong..."
    exit 1
fi
