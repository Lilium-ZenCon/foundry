
def order_list_and_median(lst):
    # Sort the list in ascending order
    lst_sorted = sorted(lst)
    
    # Calculate the median
    length = len(lst_sorted)
    if length % 2 == 0:
        median = (lst_sorted[length // 2] + lst_sorted[length // 2 - 1]) / 2.0
    else:
        median = lst_sorted[length // 2]
    
    return lst_sorted, median

# Example usage:
lst = [1500, 1550, 1400, 1600, 1650, 1700, 1800, 2000, 2500, 1850,
       1900, 2100, 2300, 2200, 2400, 2750, 2800, 2900, 3000, 300]

sorted_list, median_value = order_list_and_median(lst)
print("Sorted list:", sorted_list)
print("Median:", median_value)
