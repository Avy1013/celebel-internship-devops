cd "week_2_GIT||linux/"
cd merge_conflict/
echo "Hello, this is new content." > new.txt
git add new.txt
git commit -m "Add new.txt to main branch"

git checkout -b new  # Create and switch to new branch
echo "This is conflicting content." > new.txt  
git add new.txt
git commit -m "Modify new.txt on new branch"

git checkout main  # Switch to main branch
git merge new  # Merge new branch into main (conflict occurs)

# Edit new.txt to resolve conflict

git add new.txt

git push origin main  # Push changes to main branch

git checkout main
git branch -d new