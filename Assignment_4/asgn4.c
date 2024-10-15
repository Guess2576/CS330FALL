#include "asgn4.h"

// Main function for testing the conversions
int main() {
    int decimal = 10;
    printf("Decimal: %d\n", decimal);

    // Convert decimal to binary and print
    int *binaryArray = convertDecToBin(decimal);
    printf("Binary: ");
    printMyBinaryNum(binaryArray);

    // Convert binary back to decimal and print
    int binaryToDec = convertBinToDec(binaryArray);
    printf("Binary to Decimal: %d\n", binaryToDec);

    // Convert decimal to hex and print
    int *hexArray = convertDecToHex(decimal);
    printf("Hexadecimal: ");
    printMyHexNum(hexArray);

    // Convert hex back to decimal and print
    int hexToDec = convertHexToDec(hexArray);
    printf("Hex to Decimal: %d\n", hexToDec);

    // Free allocated memory
    free(binaryArray);
    free(hexArray);

    return 0;
}