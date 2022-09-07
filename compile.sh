directory=$1
outfile="./$directory.lua"
rm -f $outfile
for file in $(ls ./$directory)
do
echo "-- $file
$(cat ./$directory/$file)
" >> $outfile
done
