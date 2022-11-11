def main():
    counter = 0
    total = 0
    max_value=0
    min_value=10000000
    inputFile = open('power_values.txt', 'r')

    for numbers in inputFile:
        numbers = float(numbers.rstrip())
        if max_value < numbers:
            max_value=numbers
        if min_value > numbers:
            min_value=numbers

        total += numbers
        counter += 1   
    inputFile.close()


    print('Max:', max_value)
    print('Min:', min_value)
    print('Count:', counter)
    print('Total:', total)
    print('Average:', total / counter)

    range=max_value-min_value
    print('Range:', range)

    percentage=range*0.1
    print('percentage:', percentage)


    counter = 0
    total = 0
    inputFile = open('power_values.txt', 'r')
    outputFile = open('power_values_filtered.txt', 'a')
    averageFile = open('power.txt', 'a')

    for numbers in inputFile:
        numbers = float(numbers.rstrip())
        if max_value-percentage < numbers:
            total += numbers
            counter += 1  
            outputFile.write(str(numbers)+"\n")

    print('Average:', total / counter)
    averageFile.write(str(total / counter)+"\n")

    inputFile.close()
    outputFile.close()


    

main()