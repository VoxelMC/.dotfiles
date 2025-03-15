for i in `ls | grep -v "\..*$"`
do
	echo ":: copying" $i "to /usr/local/lib"
	sudo rm /usr/local/bin/t-$i
	sudo cp $i /usr/local/bin/t-$i
done

# cat ~/.scripts/!(*.*)
