#!/data/data/com.termux/files/usr/bin/bash        clear
echo "UniversalPay 1.0.0 - A maquininha de pagamento universal."
echo "Agradecimento: Cecilía Devêza, Criadora da API aqui usada."
mkdir -p $PREFIX/share/universalpay 2>/dev/null
if [[ "$(cat $PREFIX/share/universalpay/universalpayrun.txt 2>/dev/null)" != "1" ]]; then
echo "Instalação dos pacotes da máquina começará em 5 segundos."
sleep 5
pkg update -y
pkg upgrade -y
pkg install zbar -y
pkg install wget -y
pkg install jq -y
pkg install nodejs -y
npm install qrcode-terminal -y
echo "1" > $PREFIX/share/universalpay/universalpayrun.txt
clear
read -p "Seu nome completo: " nome
read -p "Sua cidade: " cidade
read -p "Sua chave PIX: " pix
echo "$nome" > $PREFIX/share/universalpay/nome.txt
echo "$cidade" > $PREFIX/share/universalpay/cidade.txt
echo "$pix" > $PREFIX/share/universalpay/pix.txt
fi
clear
while true; do
echo "UniversalPay 1.0.0 - A maquininha de pagamento universal" | fold -s -w 177

read -p "Solicitar que cliente digite o CPF aqui: " cpfcliente
echo "$cpfcliente" >> $PREFIX/share/universalpay/clientes.txt
sleep 2

nome=$(cat $PREFIX/share/universalpay/nome.txt)
cidade=$(cat $PREFIX/share/universalpay/cidade.txt)
pix=$(cat $PREFIX/share/universalpay/pix.txt)
nomeuri=$(echo -n "$nome" | jq -sRr @uri)
cidadeuri=$(echo -n "$cidade" | jq -sRr @uri)
chaveuri=$(echo -n "$pix" | jq -sRr @uri)

curl -s -o "$PREFIX/share/universalpay/v1.png" "https://gerarqrcodepix.com.br/api/v1?nome=$nomeuri&cidade=$cidadeuri&saida=qr&chave=$chaveuri"

resultadoqr=$(zbarimg "$PREFIX/share/universalpay/v1.png" 2>/dev/null | grep 'QR-Code:' | cut -d ':' -f 2)
qrcode-terminal "$resultadoqr"

read -p "Pressione Enter para continuar..." enter | fold -s -w 177
rm $PREFIX/share/universalpay/v1.png
clear
done
