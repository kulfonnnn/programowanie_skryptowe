import hashlib
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.primitives import serialization

#funkcja hashujaca
def compute_file_hash(file_path, algorithm='sha256'):
    """Compute the hash of a file using the specified algorithm."""
    hash_func = hashlib.new(algorithm)
    
    with open(file_path, 'rb') as file:
        # Read the file in chunks of 8192 bytes
        while chunk := file.read(8192):
            hash_func.update(chunk)

    #wypisanie hasha do sprawdzenia poprawnosci online
    print("Hash pliku (hex):")
    print(hash_func.hexdigest())


    return hash_func.hexdigest()



# Funkcja do podpisywania hasha pliku
def podpisz_hash(hash_hex, private_key_path):
    digest= bytes.fromhex(hash_hex)  # konwersja heksadecymalnego hasha do bajtów

    #wczytanie klucza prywatnego z pliku PEM
    with open(private_key_path, "rb") as f:    #read binary
        private_key = serialization.load_pem_private_key(
            f.read(),
            password=None  # jeśli jest hasło, to podaj tutaj
        ) #ładuje klucz prywatny z pliku PEM

    #generowanie podpisu cyfrowego
    signature = private_key.sign(
        digest,  # kodujemy hash do bajtów
        padding.PKCS1v15(),  # klasyczny padding dla RSA
        hashes.SHA256()      # musi być zgodny z użytym algorytmem hashującym
    )
    
    #zapisanie podpisu do pliku
    with open("podpis.sig", "wb") as f:
        f.write(signature)
    
    #wypisanie podpisu do sprawdzenia poprawnosci online
    print("Podpis (hex):")
    print(signature.hex())


#pobranie sciezki do pliku
plik = input("Podaj sciezke pliku do podpisania: ")  #pobranie sciezki do pliku

#pobranie sciezki do klucza prywatnego
klucz_prywatny = input("Podaj sciezke do klucza prywatnego (PEM): ") 

#obliczenie hasha pliku
hash_hex = compute_file_hash(plik) 

#generowanie podpisu cyfrowego
podpisz_hash(hash_hex, klucz_prywatny)  
