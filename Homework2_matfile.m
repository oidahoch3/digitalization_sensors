tagreadshw2.Timestamp = datetime(tagreadshw2.Timestamp, 'InputFormat','uuuu-MM-dd HH:mm:ss,SSS');

desired_tag = '4D554C';

condition = strncmpi(string(tagreadshw2.EPC), desired_tag, 6);

filtered_table = tagreadshw2(condition, :);

% creating a tag and a condition for each reader.
desired_tag_rd_1 = 'Rd1';
desired_tag_rd_2 = 'Rd2';

condition_rd_1 = strncmpi(string(filtered_table.ReaderAntenna), desired_tag_rd_1, 3);
condition_rd_2 = strncmpi(string(filtered_table.ReaderAntenna), desired_tag_rd_2, 3);

% creating a list for each reader.
reader_1 = filtered_table(condition_rd_1, :);
reader_2 = filtered_table(condition_rd_2, :);

% creating a new table with the median timestamps of all unique EPCs for
% each reader
median_rd_1 = groupsummary(reader_1, 'EPC', 'median', 'Timestamp');
median_rd_2 = groupsummary(reader_2, 'EPC', 'median', 'Timestamp');

joined_median_times = innerjoin(median_rd_1, median_rd_2, 'Keys', 'EPC');

joined_median_times.ret_time = joined_median_times.median_Timestamp_median_rd_2 - joined_median_times.median_Timestamp_median_rd_1;

%plotting
boxplot(datenum(joined_median_times.ret_time))