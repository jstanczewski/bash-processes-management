#!/bin/bash

# Funkcja symulująca prace dźwigu 1
function dzwig1 {
  while true; do
    # Sprawdzanie czy bufor nie jest pełny
    if [ "$(ls -A buffer | wc -l)" -lt 2 ]; then
      # Przenoszenie materiału budowlanego do bufora
	material="$(ls -1 dir1 | grep -m 1 -v '^dir$')"
	if [ -n "$material" ]; then
      mv "dir1/$material" buffer/
      echo "Dźwig 1: przeniesiono $material do bufora"
	else
		echo "Dzwig 1: brak plikow do przeniesienia, czekam na produkcje"
	fi
	else
      echo "Dźwig 1: bufor jest pełny, czekam na dźwig 2"
    fi
    sleep 1
  done
}

# Funkcja symulująca prace dźwigu 2
function dzwig2 {
  while true; do
    # Sprawdzanie czy bufor nie jest pusty
    if [ "$(ls -A buffer | wc -l)" -gt 0 ]; then
      # Przenoszenie materiału budowlanego do miejsca 2
      material="$(ls -1 buffer | grep -m 1 -v '^dir$')"
      if [ -n "$material" ]; then
       mv "buffer/$material" dir2/
      echo "Dźwig 2: przeniesiono $material do miejsca 2"
	else
	echo "Dzwig 2: brak plikow do przeniesienia, czekam na dzwig 1"    
	fi	
else
      echo "Dźwig 2: bufor jest pusty, czekam na dźwig 1"
    fi
    sleep 1
  done
}

# Funkcja uruchamiająca dźwigi i oczekująca na sygnał
function start_simulator {
  echo "Symulator dźwigów został uruchomiony"
  
  # Uruchomienie dźwigów w tle
  dzwig1 &
  dzwig2 &
  
  # Oczekiwanie na sygnał
  while true; do
    read -r signal
    case "$signal" in
      "USR1")
        echo "Uruchamiam dźwigi"
        # Uruchomienie dźwigów w tle
        dzwig1 &
        dzwig2 &
        ;;
      "SIGINT")
        echo "Kończę pracę dźwigów"
        # Zabicie procesów dzwig1 i dzwig2
        pkill -f dzwig1
        pkill -f dzwig2
        exit 0
        ;;
      *)
        echo "Nieznany sygnał: $signal"
        ;;
    esac
  done
}

# Uruchomienie symulatora
start_simulator
