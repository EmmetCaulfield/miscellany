
default: Zoom.html Meetings.html

Zoom.html: header.html example-tbody.html end-table.html instructions.html footer.html
	cat $^ > $@

Meetings.html: header.html work-tbody.html end-table.html footer.html
	cat $^ > $@

clean:
	rm -f Zoom.html Meetings.html *~
