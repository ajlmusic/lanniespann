$myfile = fopen("/home/nehetek/divine-essentials-mailing-list.txt", "w") or die("Unable to open file!");
echo $_POST['list'];
fwrite($myfile, $_POST['list']);
