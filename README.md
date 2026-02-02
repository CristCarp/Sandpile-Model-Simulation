# Sandpile Model Simulation

## Overview
This project, presented in french, explores the sandpile model introduced by Bak, Tang and Wiesenfeld (BTW), a canonical example of Self-Organized Criticality (SOC). The objective is to study how simple local interaction rules can lead to complex global behavior, characterized by local correlations, power-law distributions and 1/f noise. It is implemented in SAS.

## Theoretical Background
The sandpile model illustrates how a system can naturally evolve toward a critical state without external parameter tuning. In this critical state, small perturbations may trigger avalanches of all sizes.

## Repository structure
- `The Sandpile Model.pdf` - a PDF version of the report
- The `Code` folder, containing the `Sandpile Random.sas` and `Sandpile Centered.sas` scripts, implemented and studied in the academic framework

## Models Implemented
Two versions of the sandpile model are studied:

### Centered Model
- Sand grains are deposited at a fixed location (center or predefined points)
- The system is fully deterministic, since we know how the sand piles will develop
- The final configuration is independent of the order of topplings
- Reveals fractal and symmetric structures

### Random Model
- Sand grains are deposited randomly on the grid
- Avalanches of variable size and duration emerge
- Empirical distributions of avalanche size and duration are analyzed
- Power-law behavior is verified through log–log regression

## Tools
- SAS

## Authors
Cristian Carp  
Oscar Stemmelin  
Damien Lebas
