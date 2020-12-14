Authors:
David Currie
Geraldine Smith
Mark Donaldson
Calum Sey

## Guide to authors: branch n merge

0. Start at the top level of the git repo.
1. Create new branch for you to work on your feature
```
gco -b feature/name_of_your_feature
```
2. Complete work on your feature and commit changes
```
git add .
git commit -m "adds name_of_my_feature"
```
3. Jump over to main branch
```
gco main
```
4. Pull latest version. Tell other authors you are in the process of merging.
```
git pull
```
5. Jump back to your feature branch
```
gco feature/name_of_your_feature
```
6. Merge main (merge any new commits from main that don't exist in your feature)
```
git merge main
```
7. Resolve any conflicts and **verify the app is working**. 
8. Push working app
```
git push
```
Git will give you code to copy
```
git push --set-upstream origin feature/name_of_your_feature
```
9. Jump over to the main branch
```
gco main
```
10. Merge feature branch (update main branch to include your feature)
```
git merge feature/name_of_your_feature
```
11. Push up main branch
```
git push
```