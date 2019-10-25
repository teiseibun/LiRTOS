#ifndef __TEST_DRIVERS_H__
#define __TEST_DRIVERS_H__

void gpio_init(void);
void uart3_init(void);

void uart3_putc(char c);
void uart3_puts(char *s, int len);

#endif
