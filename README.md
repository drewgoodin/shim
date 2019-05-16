Shim is a Perl/[PSGI](https://plackperl.org) blog platform.

You'll need a few Perl modules:

---

- HTML::Mason
- URL::Encode
- Plack
- DateTime
- Text::Markdown

---

To start blogging, clone the repository, change to the project root, and run ```plackup```. Navigate to localhost:5000 in your browser and you should see the front page. Tack /admin onto that, and you'll be prompted for a login, and if successful, you will be brought to the area to add, edit, and delete posts.

The default username and password are on line 25 of app.psgi; modify them! These values are in plain text in app.psgi and thus not highly secure. The application uses Basic HTTP authentication to access the admin area. If public facing, this application should sit behind a reverse proxy with HTTPS.

You can write your posts in Markdown! Not the extended Git version, though. 

Shim includes (and relies on) a copy of [Slurm](https://github.com/goodind1/slurm), a PSGI handler for HTML::Mason applications.
