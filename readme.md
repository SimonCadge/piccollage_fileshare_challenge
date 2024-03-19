# Simon Cadge PicCollage File Sharing Take Home Quiz

Welcome to my PicCollage take home quiz. This is now a fully featured MVP.  
The homepage at "/" links to the new file upload page, and then once a file has been uploaded you are taken to the page where the user can download the file.  
There is no way to list all of the files, so unless a user can guess the UUID of a file that someone else has uploaded they shouldn't be able to access it.  

Tests make use of active storage fixtures so we can easily test the file upload/download functionality.  
Running `rails test:all` will run the Controller, Model and System tests for SharedFiles.  

Expired links are now no longer downloadable.  

Added a homepage which links to the create new shared file page, made the shared file pages route back to home, and removed the shared files index. The app now meets the minimum requirements for the quiz.

Added user registration and session management. You're now not able to create file share links unless you are logged in.  
Also created a javascript controller using Stimulus to allow you to copy the share link to the clipboard just by pressing a button.  

The user page now lists all of the files that user has created. A user can revoke the link to a file if they are the person who originally uploaded it, but if they are just viewing it that option doesn't appear.

When creating a link you now have the choice between it being short(10 minutes), long(60 minutes), or forever(won't ever expire).

Next steps:  
 - Improve UI.
 - Deploy to AWS and integrate with S3.

### To Run:
 1. Ensure docker desktop / docker engine is running on your system.
 2. Create a .env file in the root directory containing the following variables:
    - DB_PASSWORD='whatever password you like'
    - DB_USER='whatever username you like'
    - RAILS_MASTER_KEY='the encryption key generated by rails. This shouldn't be uploaded to version control so you'll need to ask me for this personally or generate a new one for yourself by deleting the `credentials.ymc.enc` file and then running `rails credentials:edit`
 3. Run `docker compose up --build`
    - This will start the postgres db first, wait for the db healthcheck to show as healthy, and then start the rails app
    - The rails app will be accessible at http://localhost:3000/up