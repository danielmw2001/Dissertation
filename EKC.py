#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jan 26 14:57:31 2024

@author: danmw
"""

import os
import pandas as pd
import wbgapi as wb
import matplotlib.pyplot as plt
from statsmodels.tsa.stattools import adfuller
from statsmodels.tsa.vector_ar.vecm import coint_johansen
import numpy as np

os.chdir("/Users/danmw/Desktop/Diss")

#define econmy code list for future use
economies = ['SAU','BHR','KWT','IRQ','ARE','QAT','OMN']
series = ["NY.GDP.MKTP.CD",'EN.ATM.CO2E.KT','NY.GDP.MKTP.KD.ZG']

#Use wb API to import data as a dataframe
df = wb.data.DataFrame(series , economy = economies)

#Data available for all countries from 1990 - 2020, clean data to remove NaN
df = df.loc[:, 'YR2001':'YR2020']


#plotting data to check it looks ok 
for serial in series:
    filtered_df = df.loc[(slice(None), serial), :]
    filtered_df = filtered_df.reset_index(level='series', drop=True)
    filtered_df = filtered_df.reset_index(level='economy', drop=True)   
    plt.figure()
    plt.title(serial)
    for econ in range(len(economies)):
        plt.plot(filtered_df.iloc[econ])
    plt.legend(economies)

#test for unit roots
for index, row in filtered_df.iterrows():
    exec(f"adf_result_{index} = adfuller(row)")

#cointegration tests
coint_data = df.loc[(economies, ['EN.ATM.CO2E.KT', 'NY.GDP.MKTP.KD.ZG']), :]
for econ in economies:
    # Extract the GDP and CO2 series for the country 'econ'
    gdp_series = coint_data.loc[(econ, 'NY.GDP.MKTP.KD.ZG')].values
    co2_series = coint_data.loc[(econ, 'EN.ATM.CO2E.KT')].values

    # Stack them horizontally to prepare for the cointegration test
    country_data = np.column_stack((gdp_series, co2_series))

    # Perform the Johansen cointegration test on this country's data
    johansen_test = coint_johansen(country_data, det_order=0, k_ar_diff=1)
    
    # Output the test statistics for this country
    print(f"Cointegration test for {econ}:")
    print(f"Trace statistic: {johansen_test.lr1}")
    print(f"Max eigen statistic: {johansen_test.lr2}")
    print(f"Critical values (90%, 95%, 99%): {johansen_test.cvt}")
    print()