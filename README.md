# kamalavalli 
**1) Create a file and add executable permission to all users (user, group and others):**
- touch sample1
- ls -lrt
- chmod +755 sample1
- ls -lrt

**2) create a file and remove write permission for group user alone.**
   - touch sample2
   - ls -lrt
   - chmod g-w sample2
   - ls-lrt

**3) Create a file and add a softlink to the file in different directory (Eg : Create a file in dir1/dir2/file and create a softlink for file inside dir1)**
   - mkdir -p dir1/dir2
   - cd dir1
   - touch dir2/sample3
   - ls
   - ln -s dir2/sample3 link3
   - ls -l

**4) Use ps command with options to display all active process running on the system**
  ps -ef

**5) Create 3 files in a dir1 and re-direct the output of list command with sorted by timestamp of the files to a file**
  - cd dir1
  - touch file1 file2 file3
  - ls -lrt
  - ls -lt
  - ls -lt > sorted.txt
  - cat sorted.txt
  




   

