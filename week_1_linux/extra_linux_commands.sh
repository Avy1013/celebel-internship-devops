

mkdir -p sample_dir/sub_dir
echo -e "Line 1\nLine 2\nLine 3\nLine 4\nLine 5" > sample_dir/file1.txt
echo -e "Line A\nLine B\nLine C\nLine D\nLine E" > sample_dir/sub_dir/file2.txt

#1
echo "Displaying the first 3 lines of file1.txt:"
head -n 3 sample_dir/file1.txt

#2
echo "Displaying the last 3 lines of file2.txt:"
tail -n 3 sample_dir/sub_dir/file2.txt

#3
echo "Concatenating and displaying file1.txt and file2.txt:"
cat sample_dir/file1.txt sample_dir/sub_dir/file2.txt

#4
echo "Searching for 'Line 2' in file1.txt:"
grep 'Line 2' sample_dir/file1.txt

#5
echo "Finding .txt files in sample_dir:"
find sample_dir -name "*.txt"

#6
echo "Listing current processes:"
ps aux | head -n 5

#7
echo "Displaying disk usage:"
df -h | head -n 5


#8
echo "Renaming file1.txt to newfile.txt:"
rename 's/file1/newfile/' sample_dir/file1.txt
ls -l sample_dir/newfile.txt

#9
echo "Displaying information about file2.txt:"
stat sample_dir/sub_dir/file2.txt

#10
echo "Creating a tarball of sample_dir:"
tar -cvf sample_dir.tar sample_dir


echo "Cleaning up created files and directories."
rm -r sample_dir sample_dir.tar
