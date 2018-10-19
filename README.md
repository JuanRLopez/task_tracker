# TaskTracker

## Design Decisions:
* I made users a very simple data object with just a username and an id as core data. No more user data than that was needed for hw06.
* When inputting user information for a form, I ask for the username instead of an id. This is more human friendly, as people will see each others usernames, not ids. The server takes care of conversions from username to id.
* I created a "nobody" user, with an id of -1, to serve as a default user. Whenver a username input is left empty, the server will default to "nobody".
* Each task has a an id, description, time worked, completed, and a user id. This was the core data needed for this task.
* I seperated the task form into "new-form" and "edit-form" because I wanted to the user to ive different data for each occassion. Having both "create" and "edit" use the same form didnt really make sense to me.
* I decided to display all of the tasks on the main page, once a user is logged in, because task tracking is the main objective of the site. It would not make sense to display something like user info or anything else.
* (currently disabled) I added an "Actions" drop-down menu for each task on the main page. This provides a user easy acess to the "Edit" and "Delete" functionalities.
* I added the "New Task" link to the nav-bar for easy of access. It should be easy for users to add tasks, and not have to click and scroll around until they found the creation page.
* (cosmetic): I tried to make everything look the best it could.
