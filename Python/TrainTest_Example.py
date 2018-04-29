import matplotlib
import matplotlib.pyplot as plt
import numpy as np
from pylab import *
import pyodbc
import pandas as pd

# Functions
def yes_no(answer):
    yes = set(['yes','y', 'ye', ''])
    no = set(['no','n'])
     
    while True:
        choice = input(answer).lower()
        if choice in yes:
           return True
        elif choice in no:
           return False
        else:
           print ("Please respond with 'yes' or 'no'\n")
           
# end function

def set_up():
# Number in seed is way to always get same numbers, without - uses current day time
    np.random.seed(2)

    global pageSpeeds
    pageSpeeds = np.random.normal(3.0, 1.0, 100)
    global purchaseAmount
    purchaseAmount = np.random.normal(50.0, 30.0, 100) / pageSpeeds

    global trainX
    trainX = pageSpeeds[:80]
    global testX
    testX = pageSpeeds[80:]

    global trainY
    trainY = purchaseAmount[:80]
    global testY
    testY = purchaseAmount[80:]

def rpt1():
    
    l_answer = yes_no("Print the plot for normal distribution? ")
    if l_answer:
        c1 = plt.figure(1)
        plt.title(r'Normal Distribution')
        c1.show(scatter(pageSpeeds, purchaseAmount, color="red"))

    l_answer = yes_no("Print the plot for trainX, trainY? ")
    if l_answer:
        c2 = plt.figure(2)
        plt.title('Train')
        c2.show(scatter(trainX, trainY, color="green"))

    l_answer = yes_no("Print the plot for testX, testY? ")
    if l_answer:
        c3 = plt.figure(3)
        plt.title('Test')
        c3.show(scatter(testX, testY))


def rpt2():
    
    # Two subplots, unpack the axes array immediately
    f, (ax1, ax2, ax3) = plt.subplots(1, 3, sharey=True)
    
    ax1.scatter(pageSpeeds, purchaseAmount, color="red")
    ax1.set_title(r'Normal Distribution')

    ax2.scatter(trainX, trainY, color="green")
    ax2.set_title(r'Train')

    ax3.scatter(testX, testY)
    ax3.set_title(r'Test')

    plt.show()
    

# ------------------------------------

def func_polynomial():
    x = np.array(trainX)
    y = np.array(trainY)

    p4 = np.poly1d(np.polyfit(x, y, 4))

    xp = np.linspace(0, 7, 100)
    axes = plt.axes()
    axes.set_xlim([0,7])
    axes.set_ylim([0, 200])
    plt.scatter(x, y)
    plt.plot(xp, p4(xp), c='r')
    plt.show()


# ------------------------------------

def func_regr():
    
    from sklearn.metrics import r2_score

    testx = np.array(testX)
    testy = np.array(testY)

    p4 = np.poly1d(np.polyfit(testx, testy, 8))
    
    r2 = r2_score(testy, p4(testx))

    trainx = np.array(trainX)
    trainy = np.array(trainY)
    
    p4 = np.poly1d(np.polyfit(trainx, trainy, 8))
    
    p2_1 = r2_score(trainy, p4(trainx))

    print (r2," - ",p2_1)

# ------------------------------------
def func_sql():

    sql =  """ SELECT b.[UA],[nppes_provider_zip],[nppes_provider_state],[line_srvc_cnt]
            ,[average_Medicare_allowed_amt],[stdev_Medicare_allowed_amt],[year_nbr]
            FROM [SQL2008R2_57153_cartridge].[dbo].[cms_puf] a
            inner join [dbo].[zip_2010] b on substring(a.[nppes_provider_zip],1,5) = b.[ZCTA5]
            where [nppes_provider_state] = 'IL' and [hcpcs_code] = '66984' and year_nbr = 2012 """
    
    try:
        conn = pyodbc.connect("driver={SQL Server};server=sql2k804.discountasp.net;database=SQL2008R2_57153_cartridge;uid=sa1519;pwd=dballc", timeout=15)
        # cursor = conn.cursor()
        try:
            # cursor.execute(sql)
            #for row in cursor.fetchall():
            #    print (row)
            df = pd.read_sql(sql, conn)
            print (df)
        except Exception as e:
            print ("SQL Error")
            return None
        finally:
            conn.close()
    except TimeoutError as e:
        print ("Not Ready: ", e)
        return None


if __name__ == "__main__":
    set_up()
    fmt = yes_no("Enter 'Yes' to continue: ")
    if fmt:
        fmt = yes_no("Enter 'Yes' for report type 1: ")
        if fmt:
            rpt1()
        else:
            rpt2()
    else:
        func_polynomial()
        func_regr()

    fmt = yes_no("Enter 'Yes' to For SQL Demo: ")
    if fmt:
        func_sql()
        
    print ("Done")
    
    
    
