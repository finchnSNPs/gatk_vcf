FILES=$(ls -1 gnotpgvcf_1508409_*)

for i in $FILES
do
	echo $i>>check_complete.out
	tail -2 $i>>check_complete.out
done
