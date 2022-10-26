T = readtimetable("seclog.xlsx");
T.Properties.DimensionNames(1,1) = "datetime";
T.Properties.VariableNames(1) = "EventCode";
T.Properties.VariableNames(2) = "EventCategory";
D.date = day(T.datetime);
numOfRows = size(D.date, 1);
Range = range(D.date(:,1));
i = 0;
k = 1;
l = 1;
m = 1;
dateNew = D.date(m,1);
dateOld = D.date(m,1);
while i <= Range
    if m == numOfRows
        break;
    end
	dateNew = D.date(m,1);
	if dateNew == dateOld
		if (mod(i,7) == 1 || mod(i,7) == 3  || mod(i,7) == 5)
			Odd(l,:) = seclog(m,:);
            l = l + 1;
            m = m + 1;
		elseif (mod(i,7) == 2 || mod(i,7) == 4 || mod(i,7) == 6 || mod(i,7) == 0)
			Even(k,:) = seclog(m,:);
            k = k + 1;
            m = m + 1;
		end
	else 
		dateOld = dateNew;
        i = i + 1;
	end
end
Etime = table2timetable(Even);
Otime = table2timetable(Odd);
Etime.Properties.DimensionNames(1,1) = "datetime";
Etime.Properties.VariableNames(1) = "EventCode";
Etime.Properties.VariableNames(2) = "EventCategory";
Otime.Properties.DimensionNames(1,1) = "datetime";
Otime.Properties.VariableNames(1) = "EventCode";
Otime.Properties.VariableNames(2) = "EventCategory";

Etime.hr_of_day = hour(Etime.datetime);
Otime.hr_of_day = hour(Otime.datetime);

EH=groupsummary(Etime,["hr_of_day","EventCode"], 'IncludeEmptyGroups', true);
OH=groupsummary(Otime,["hr_of_day","EventCode"], 'IncludeEmptyGroups', true);

E1=groupsummary(Etime,"hr_of_day");
O1=groupsummary(Otime,"hr_of_day");

E2 = groupsummary(EH, "hr_of_day", @(x) { x' }, ["EventCode", "GroupCount"]);
O2 = groupsummary(OH, "hr_of_day", @(x) { x' }, ["EventCode", "GroupCount"]);

Ehrs = E2.hr_of_day;
Ecounts = cell2mat(E2.fun1_GroupCount(:));
Ecodes = E2.fun1_EventCode{1};

Ohrs = O2.hr_of_day;
Ocounts = cell2mat(O2.fun1_GroupCount(:));
Ocodes = O2.fun1_EventCode{1};

Eb = bar(Ehrs, Ecounts, 'stacked','FaceColor','flat');
for k = 1:size(Ecounts,2)
 Eb(k).CData = k;
end
grid on
legend(num2cell(string(Ecodes)))

b = bar(Ohrs, Ocounts, 'stacked','FaceColor','flat');
for k = 1:size(Ocounts,2)
 b(k).CData = k;
end
grid on
legend(num2cell(string(Ocodes)))
