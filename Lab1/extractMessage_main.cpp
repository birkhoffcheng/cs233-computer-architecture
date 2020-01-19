/**
 * @file
 * This file contains code to run your extractMessage function
 * to facilitate testing.
 *
 * We will not look at this file during grading, so don't put code
 * you want graded here.
 */


#include <exception>
#include <iostream>
#include <cstdio>
#include <cstring>
#include "extractMessage.h"

using namespace std;
const char DEFAULT_MESSAGE[] = { 93, 223, 134, 215, 0, 254, 223, 0, 199, 191, 9, 29, 32, 207, 231, 0, 77, 28, 185, 88, 128, 251, 253, 0, 163, 190, 174, 223, 32, 207, 231, 0, 163, 67, 169, 16, 74, 255, 250, 0, 1, 1, 1, 1, 1, 1, 0, 0};
const int DEFAULT_MESSAGE_LENGTH = 48;

/*
 * Returns the length of a string if it were padded to the nearest multiple of 8. 
 *
 * @param str the string that we're looking to find the padded length for
 * @returns an integer describing the padded length of the message
 */
int paddedLength(const char *str){
  return (strlen(str) + 7) & ~0x7;
}

/*
 * Returns a copy of a string extended to the specified length, extended by adding zeros
 *
 * @param str the string to be padded
 * @param length the desired length for the new string
 * @returns the new string
 */
const char *paddedCopy(const char *str, int newlength){
  // allocate a new string; zero it out, and then copy the string argument over the zeros
  char *newstr = new char[newlength];
  bzero(newstr, newlength);
  strncpy(newstr, str, newlength);

  return newstr;
}

/*
 * Function to get the message from the commandline arguments.
 * @param argc The number of commandline arguments
 * @param argv The array of character pointers for each commandline argument
 */
const char *get_message(int argc, char *argv[]) {
  string msg = "";
  for (int i = 1 ; i < argc ; i ++) {
    msg += argv[i];
   msg += " ";
  }
  msg.resize(msg.size() - 1);
  const char *msg_as_char_array = msg.c_str();
  char *retval = new char[strlen(msg_as_char_array)];
  strcpy(retval, msg_as_char_array);
  return retval;
}

/*
 * Function prints the message given the length of the message and the character pointer to the beginning.
 * @param message Pointer to the beginning of the message
 * @param Length of the message
 */
void print_message(const char *message, int length) {
  for (int i = 0 ; i < length; i ++) {
    printf("%c", message[i]);
  }
  printf("\n");
}

/*
 * Function prints the message as an array of the ASCII values of the characters.
 * @param message Pointer to the beginning of the message
 * @param Length of the message
 */
void print_message_as_char_array(const char *message, int length) {
  printf("{ %d", (unsigned char) message[0]);
  for (int i = 1 ; i < length; i ++) {
    printf(", %d", (unsigned char) message[i]);
   
  }
  printf("}\n");
}

int main(int argc, char * argv[]) {
   const char *message_in = DEFAULT_MESSAGE;
  int length = DEFAULT_MESSAGE_LENGTH;
  if (argc > 1) {
      message_in = get_message(argc, argv);   
      length = paddedLength(message_in);
      message_in = paddedCopy(message_in, length);
  }

  printf("Input message: \n");
   print_message(message_in, length);

  printf("\nOutput message: \n");
  try {
     char *message_out = extractMessage(message_in, length);
    print_message(message_out, length);
    
    printf("\nWant to encode your own messages?  Here's the output as a char[%d] initializer:\n", length);
    print_message_as_char_array(message_out, length);
  } catch (const exception & e) {
    cerr << e.what() << "\n";
    return 1;
  }
}
