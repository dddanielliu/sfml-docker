image_name="sfml"
port=3000

docker ps -q --filter "ancestor=$image_name" | xargs -I {} docker stop {} | xargs -I {} echo "Stopped {}"

if ! [ -z "$(docker images -q $image_name) 2> /dev/null)" ]; then
    docker build -t $image_name .;
fi


docker run --rm -itd -p $port:3000 $image_name bash
