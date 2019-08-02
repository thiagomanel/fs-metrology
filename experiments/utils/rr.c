#include <unistd.h>
#include <sys/types.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>

const char content[] = "hello world\n";
char buf[100];

int main() {
  int fd = open("./foo.txt", O_CREAT | O_WRONLY);

  write(fd, content, strlen(content));
  close(fd);

  fd = open("./foo.txt", O_RDONLY);
  read(fd, buf, 100);
  close(fd);

  printf("[from fd=%d]: %s", fd, buf);


  return 0;
}
