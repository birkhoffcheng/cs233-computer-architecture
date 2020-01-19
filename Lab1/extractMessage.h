/**
 * @file
 * Contains the declaration of the extractMessage function.
 */

#ifndef EXTRACT_MESSAGE_H
#define EXTRACT_MESSAGE_H

/**
 * Extracts a message from an encoded message. See the handout for the details
 * of how the message is encoded.
 *
 * @param message_in The string (char array) to extract from.
 * @param length The length of that string (don't trust strlen); must be a multiple of 8.
 * @return The extracted message.
 */
char *extractMessage(const char *message_in, int length);

#endif
