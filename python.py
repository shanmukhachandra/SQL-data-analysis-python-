
1. def convert_minutes(minutes):
    hours = minutes // 60
    mins = minutes % 60

    result = ""

    if hours > 0:
        if hours == 1:
            result += f"{hours} hr "
        else:
            result += f"{hours} hrs "

    if mins > 0:
        if mins == 1:
            result += f"{mins} minute"
        else:
            result += f"{mins} minutes"

    return result.strip()


# Examples
print(convert_minutes(130))  # 2 hrs 10 minutes
print(convert_minutes(110))  # 1 hr 50 minutes




2. def remove_duplicates(s):
    result = ""

    for char in s:
        if char not in result:
            result += char

    return result


# Example
input_string = "programming"
print(remove_duplicates(input_string))  # progamin