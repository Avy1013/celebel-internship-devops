

# Create file
touch example.txt


chmod u+rwx example.txt  
chmod g+rx example.txt   
chmod o+r example.txt   

echo "Current permissions:"
ls -l example.txt


chmod u-w example.txt    
chmod g+w example.txt    
chmod o-r example.txt    


echo "Updated permissions:"
ls -l example.txt
