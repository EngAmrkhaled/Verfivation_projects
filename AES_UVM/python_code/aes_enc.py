# aes_enc.py
from Crypto.Cipher import AES
import binascii
import sys

def read_key_and_data():
    try:
        with open("key.txt", "r") as f:
            lines = f.readlines()
            if len(lines) < 2:
                print("Error: key.txt should contain 2 lines (key and data)")
                sys.exit(1)
                
            key_hex = lines[0].strip()
            data_hex = lines[1].strip()
            
            # Remove any '0x' prefix if present
            if key_hex.startswith('0x'):
                key_hex = key_hex[2:]
            if data_hex.startswith('0x'):
                data_hex = data_hex[2:]
                
            return binascii.unhexlify(key_hex), binascii.unhexlify(data_hex)
    except Exception as e:
        print(f"Error reading key.txt: {e}")
        sys.exit(1)

def encrypt_aes(key, data):
    try:
        cipher = AES.new(key, AES.MODE_ECB)
        ciphertext = cipher.encrypt(data)
        return binascii.hexlify(ciphertext).decode()
    except Exception as e:
        print(f"Error during encryption: {e}")
        sys.exit(1)

def main():
    key, data = read_key_and_data()
    ciphertext = encrypt_aes(key, data)
    
    with open("output.txt", "w") as f:
        f.write(ciphertext)
    
    print(f"Encryption completed. Output: {ciphertext}")

if __name__ == "__main__":
    main()