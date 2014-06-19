#include <stdio.h>
#include <stdint.h>
#include "checksum.h"
#include "mavlink/common/mavlink.h"


int main() {
    //uint8_t abyte = 0b00001111;
    //uint16_t bbyte = 0b1111010111110000;

    //printf("8 bits: %i, 16 bits: %i \n", abyte, bbyte);
    //printf("typecasted: %i \n", (uint8_t)bbyte);
    //
    uint8_t buf[17];
    mavlink_message_t msg;
    mavlink_msg_heartbeat_pack(1, 200, &msg, MAV_TYPE_QUADROTOR, MAV_AUTOPILOT_GENERIC, MAV_MODE_GUIDED_ARMED, 0, MAV_STATE_ACTIVE);
    uint8_t len = mavlink_msg_to_send_buffer(buf, &msg);

    //uint8_t bytes[15] = 
    //{0xfe, 0x09, 0x00, 0x01, 0x02, 0x00, 0x02, 0x00, 0xd0, 0x00, 0x00, 0x00, 0x00, 0x04, 0x7b};
    //uint8_t bytes[5] = {0,1,2,127,255};
    //uint16_t checksum = crc_calculate(bytes, sizeof(bytes));

    printf("Message: ");
    int i;
    for(i = 0; i < sizeof(buf); ++i)
        printf("%.2x ", buf[i]);
    //printf("Checksum: %.4x \n", checksum);
}
