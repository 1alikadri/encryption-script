printf "Do you want to encrypt or decrypt your data: \n"
printf "1. Encrypt\n"
printf "2. Decrypt\n"
read task

case $task in
1)
    printf "Enter the name of the file you want to encrypt: \n"
    read input_file

    printf "Enter the name of the file you want your encrypted data in (use '.enc'): \n"
    read output_enc

    printf "Select the type of encryption you want: \n"
    printf "1. Symmetric encryption\n"
    printf "2. Asymmetric encryption\n"
    printf "Type 1 or 2: \n"
    read type

    case $type in
        1)
            # Symmetric encryption
            printf "Encrypting your data with OpenSSL AES (Advanced Encryption Standard)...\n"
            openssl enc -aes-256-cbc -salt -in "$input_file" -out "$output_enc"
            ;;
        2)
            printf "Name your private key file (use '.pem'): \n"
            read private_name

            printf "Enter the number of bits for the key (e.g., 2048): \n"
            read bits

            # Generate private RSA key
            printf "Generating a private RSA key...\n"
            openssl genpkey -algorithm RSA -out "$private_name" -pkeyopt rsa_keygen_bits:$bits

            printf "Name your public key file (use '.pem'): \n"
            read public_name

            # Extract public key from private key
            openssl rsa -pubout -in "$private_name" -out "$public_name"

            # Encrypt the data with pkeyutl
            printf "Encrypting your data now...\n"
            openssl pkeyutl -encrypt -inkey "$public_name" -pubin -in "$input_file" -out "$output_enc"
            ;;
        *)
            printf "Invalid encryption type selected. Exiting.\n"
            exit 1
            ;;
    esac
    ;;
2)
    printf "Select the type of decryption you want: \n"
    printf "1. Symmetric decryption\n"
    printf "2. Asymmetric decryption\n"
    printf "Type 1 or 2: \n"
    read detype

    printf "Enter the name of the encrypted file (with extension): \n"
    read enc_file

    printf "Name the file to save your decrypted data (with extension): \n"
    read dec_file

    case $detype in
        1)
            # Symmetric decryption
            printf "Decrypting your file...\n"
            openssl enc -aes-256-cbc -d -in "$enc_file" -out "$dec_file"
            ;;
        2)
            printf "Name the public key file (with extension): \n"
            read public_key

            printf "Name the private key file (with extension): \n"
            read private_key

            printf "Decrypting your data...\n"
            openssl pkeyutl -decrypt -inkey "$private_key" -in "$enc_file" -out "$dec_file"
            ;;
        *)
            printf "Invalid decryption type selected. Exiting.\n"
            exit 1
            ;;
    esac
    ;;
*)
    printf "Invalid task selected. Exiting.\n"
    exit 1
    ;;
esac
