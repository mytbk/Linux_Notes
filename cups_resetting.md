Reset CUPS settings
===================

I screw up my HP printer settings, and I can't print things anymore.

If I use hp-setup to add the printer, it says there's already a print queue. I don't want to add a new print queue. I tried to reinstall cups and hplip. I also removed /etc/cups. However, these doesn't work.

At last, I found cups store its spool files in /var/spool/cups. So I remove all the things in /var/spool/cups, and run hp-setup again. This time it worked!
