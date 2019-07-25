#include <unistd.h>
#include <sys/types.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>

const char content[] = "hello world\n";
char buf[100];

int main() {
  int fd = open("./foo.txt", O_CREAT | O_RDWR);

  pwrite(fd, content, strlen(content), 0);
  pread(fd, buf, 100, 0);
  close(fd);

  printf("%s", buf);

  return 0;
}
