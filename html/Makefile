
default: Zoom.html Meetings.html

Zoom.html:
	cat header.html example-tbody.html end-table.html instructions.html footer.html > $@

Meetings.html:
	cat header.html work-tbody.html end-table.html footer.html > $@

clean:
	rm -f Zoom.html Meetings.html *~
