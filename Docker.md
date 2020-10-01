So I am new to docker:

Here's my flow:
- First I unsuccessfully tried to run the rocker/r-rmd image, but I could not make it work.
- Next I found [this very useful blogpost](https://jlintusaari.github.io/2018/07/how-to-compile-rmarkdown-documents-using-docker/) which pointed to the rocker/verse image and provided a full on tutorial on how to run these things. I browsed through the different images that rocker provides, and I thought rocker/verse is good enough as it contains the whole of tidyverse but also tex tools which I need to run rmarkdown compiling.
- I pulled this docker image(`docker pull rocker/verse`), which by default installed the latest available version.
- Then I run the following command: `docker run --rm -p 8787:8787 rocker/verse`, and was prompted to enter another command and set a password for my login (!= rstudio), so I used rstudio1. I run the following command to set the password: `docker run -e PASSWORD=rstudio1 -p 8787:8787 rocker/rstudio`. Then I opened [`localhost:8787`](localhost:8787) in my local browser and entered the username __rstudio__ and the password __rstudio1__. And then __BOOM__ rstudio session opened up in my browser. Super cool!
- Unfortunately, `rocker/verse` does not contain rmarkdown, I could install it separately but I would rather use an image straight out of the box and avoid installing any further libraries. __So back to rocker/r-rmd!__
- Turns out I am an idiot and something was wrong with the previous `rocker/r-rmd` installation. I re-installed it, and it works fine:
```sh
docker pull rocker/r-rmd
docker run --rm -p 8787:8787 rocker/r-rmd
```
In this case, this does not actually open anything in [localhost:8787](localhost:8787), it will just open the docker image and if you have not asked it do anything it would close it straight away. This at first is unsettling.
- One must always read the documentation of anything. I went to the [docker exec documentation](https://docs.docker.com/engine/reference/commandline/exec/) and discovered I could run something like: `docker run --name rmd --rm -i -t rocker/r-rmd bash` and this will open a bash session I can interact with inside my own terminal. Once I am there I can do other things too, I can open an R session, download files from the internet using `wget` and many other things. At this stage I tested whether `rmarkdown` and pandoc were available and moved on. Fyi, I can also run something like, `docker run --name rmd --rm -i -t rocker/r-rmd R` or `docker run --name rmd --rm -i -t rocker/r-rmd tex` and that will open R or tex directly from the Docker image. 
- At this point I actually wanted to see what the options meant:

* --name: pretty clear define name of container, otherwise a random one will be generated.
* --rm: automatically remove the container when it exits
* -t, --tty: Allocate a pseudo-TTY. No idea what that means. From [this site](https://www.howtogeek.com/428174/what-is-a-tty-on-linux-and-how-to-use-the-tty-command/):
> What does the tty command do? It prints the name of the terminal you’re using. TTY stands for “teletypewriter.” 
And more about pseudo-ty [in stack-exchange](https://unix.stackexchange.com/questions/21147/what-are-pseudo-terminals-pty-tty)
* -i, --interactive: Keep STDIN open even if not attached. i.e. allows you to interact with the image, passing input as if it were your terminal.

Now why are all these necessary? I don't know yet

What I've learnt is that if I remove `-i` I cannot exit the process with Ctrl-D and if I remove `-t` nothing happens, as no terminal is created I guess.

__Most basic use:__ `docker run --name rmd --rm -t -i rocke/r-rmd`

- I can also interact with it from the background, I can append the option `-d, --background` and then send commands to be executed there:
```sh
docker run --name rmd --rm -tid rocker/r-rmd
docker exec rmd echo 'cat' # will print cat to my main terminal
```
