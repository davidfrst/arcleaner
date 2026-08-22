#!/bin/bash
echo ""
echo "===================================="
echo "  Iniciando a limpeza do Sistema... "
echo "===================================="
echo ""

sudo -v

echo ""
echo "[0/5] Removendo arquivos de download corrompidos..."
sudo rm -rf /var/cache/pacman/pkg/download-*
sudo rm -rf /var/cache/pacman/pkg/*.part

echo ""
echo "[1/5] Limpando o cache do pacman..."
sudo pacman -Sc --noconfirm

echo ""
echo "[2/5] Verificando pacotes órfãos..."
ORPHANS=$(pacman -Qdtq)

if [[ -n "$ORPHANS" ]]; then
    echo "Removendo os seguintes pacotes órfãos:"
    echo "$ORPHANS"
    sudo pacman -Rns $ORPHANS --noconfirm
else
    echo "Nenhum pacote órfão encontrado."
fi

echo ""
echo "[3/5] Limpando logs antigos..."
sudo journalctl --vacuum-time=14d

echo ""
echo "[4/5] Limpando arquivos de cache do usuário atual..."
rm -rf ~/.cache/thumbnails/*

echo ""
echo "[5/5] Verificando e limpando blocos inativos do SSD"
sudo fstrim -va

echo ""
echo "=================================="
echo "  Limpeza concluída com sucesso!  "
echo "=================================="
