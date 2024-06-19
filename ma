#include <util/delay.h>
#include "lcd/lcd.c"

// Define button pins
#define BUTTON1_PIN PA0
#define BUTTON3_PIN PA2
#define BUTTON5_PIN PA4
#define BUTTON7_PIN PA6

// Function prototypes
void init_ports(void);
void display_NIM(void);
void display_name(void);
void led_chase(int leds);
void led_alternate(void);
void display_7segment(void);

int main(void) {
    // Initialize ports and LCD
    init_ports();
    lcd_init();
    lcd_on();

    while (1) {
        if (!(PINA & (1 << BUTTON1_PIN))) {
            lcd_clear();
            lcd_puts("23.61.0256");
            led_chase(1);
        } else if (!(PINA & (1 << BUTTON3_PIN))) {
            lcd_clear();
            lcd_puts("Latif");
            led_chase(2);
        } else if (!(PINA & (1 << BUTTON5_PIN))) {
            lcd_clear();
            lcd_puts("Perintah 5 aktif");
            led_alternate();
        } else if (!(PINA & (1 << BUTTON7_PIN))) {
            lcd_clear();
            lcd_puts("23.61.0256");
            lcd_gotoxy(0, 1);
            lcd_puts("Latif");
            display_7segment();
        } else {
            PORTD = 0x00; // Turn off LEDs when no button is pressed
            PORTB = 0x00; // Turn off 7-segment display when no button is pressed
        }
    }
}

void init_ports(void) {
    // Set PORTC for LCD
    DDRC = 0xFF;
    PORTC = 0x00;

    // Set PORTD for LED array
    DDRD = 0xFF;
    PORTD = 0x00;

    // Set PORTB for 7-segment display
    DDRB = 0xFF;
    PORTB = 0x00;

    // Set PORTA for buttons
    DDRA = 0x00;
    PORTA = 0xFF;  // Enable pull-up resistors
}

void led_chase(int leds) {
    for (int i = 0; i < (8 - leds + 1); i++) {
        PORTD = (0xFF >> (8 - leds)) << i;
        _delay_ms(200);
    }
    PORTD = 0x00;
}

void led_alternate(void) {
    for (int i = 0; i < 4; i++) {
        PORTD = 0x0F;
        _delay_ms(500);
        PORTD = 0xF0;
        _delay_ms(500);
        PORTD = 0x00;
        _delay_ms(500);
    }
}

void display_7segment(void) {
    int nim[] = {0x24, 0x30, 0x02, 0x79, 0x40, 0x24, 0x12, 0x02}; //23.61.0256
    int num_values = sizeof(nim) / sizeof(nim[0]);

    while (!(PINA & (1 << BUTTON7_PIN))) {
        for (int i = 0; i < num_values; i++) {
            PORTB = nim[i];
            _delay_ms(1000);
        }
    }
    PORTB = 0x00; // Turn off 7-segment display when button is released
}
