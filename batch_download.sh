#!/bin/bash

# 检查 images.txt 文件是否存在
if [ ! -f "images.txt" ]; then
  echo "文件 images.txt 不存在，请检查。"
  exit 1
fi

# 检查 images/docker 目录是否存在
if [ ! -d "images/docker" ]; then
  echo "images/docker 目录不存在，将创建。"
  mkdir -p images/docker
fi

# 逐行读取 images.txt 文件
while IFS= read -r line; do
  # 检查行是否为空
  if [ -z "$line" ]; then
    continue
  fi
done < images.txt

echo "处理完成。"

# 逐行读取 images.txt 文件
while IFS= read -r input; do
  # 提取 repo-name、image-name 和 tag
  if [[ $input =~ ^([^/]+)/([^:]+):([^:]+)$ ]]; then
    repo_name="${BASH_REMATCH[1]}"
    image_name="${BASH_REMATCH[2]}"
    tag="${BASH_REMATCH[3]}"
    echo $tag
    file_name="${repo_name}_${image_name}_${tag}"
  elif [[ $input =~ ^([^:]+):([^:]+)$ ]]; then
    image_name="${BASH_REMATCH[1]}"
    tag="${BASH_REMATCH[2]}"
    echo $tag
    file_name="library_${image_name}_${tag}"
  else
    echo "错误：无法解析行 '$input' 的格式。"
    continue
  fi

  archs=("amd64" "arm64" "arm64v8")
  # 检查文件是否存在
  file_path="images/docker/$file_name"
  for arch in ${archs[@]};do
    if [ ! -f "${file_path}_${arch}.tar" ]; then
      echo "${file_path}_${arch}.tar not exist"
      printf "q" | python3 docker_image_puller.py -q -i "$input" -a ${arch} -r $DOCKER_MIRROR
      # 检查 Python 脚本的退出状态
      if [ $? -ne 0 ]; then
        echo "执行 Python 脚本时出现错误，输入为: $input"
        continue
      fi
    else 
      echo "${file_path}_${arch}.tar is good"
    fi
  done


done < images.txt

echo "所有镜像处理完成。"
