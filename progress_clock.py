## ProgressBar Clock app

import tkinter as windows
import tkinter.ttk as window_widget
import sys
import time


class ProgressClock(windows.Tk):
    
    def __init__(self):
        windows.Tk.__init__(self)
        self.title('Clocks')
        self.geometry('220x300')
        self.configure(menu=self._create_menu_bar())

        self.header = windows.Frame(self, bg='green', height=30)
        self.content = windows.Frame(self, bg='white')
        self.footer = windows.Frame(self, bg='grey', height=30)

        self.columnconfigure(0, weight=1)  # 100%

        self.rowconfigure(0, weight=1)  # 10%
        self.rowconfigure(1, weight=8)  # 80%
        self.rowconfigure(2, weight=1)  # 10%

        self.header.pack(fill='both', side='top')
        self.content.pack(fill='both')
        self.footer.pack(fill='both', side='bottom')

        self._fill_content()
        self.tick()  # init loop

    def _create_menu_bar(self):
        # create a menu for the menu bar
        menu_bar = windows.Menu()
        menu_bar.add_command(label="Quit", command=self.on_quit)
        return menu_bar

    def _fill_content(self):
        # create clock over the bars
        self.clock = self._create_clock()
        # create bars
        self.progressbar_year = self._create_progressbar(99, 0)
        self.progressbar_month = self._create_progressbar(11, 1)
        self.progressbar_day = self._create_progressbar(self._max_for_day(int(time.strftime('%m'))), 2)
        self.progressbar_hours = self._create_progressbar(23, 3)
        self.progressbar_minutes = self._create_progressbar(59, 4)
        self.progressbar_seconds = self._create_progressbar(59, 5)

    def _create_clock(self):
        # create clock over the bars
        clock = windows.Label(master=self.header, font=('times', 20, 'bold'), bg='green')
        clock.grid(row=0, column=0, columnspan=12)
        return clock

    @staticmethod
    def _max_for_day(month):
        return (31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)[month - 1]

    def _create_progressbar(self, maximum: int, column=0):
        # single progressbar
        progressbar = window_widget.Progressbar(
            master=self.content,
            orient=windows.VERTICAL,
            length=200,
            maximum=maximum,
            mode='determinate',
        )
        progressbar.grid(
            row=1,
            column=column,
            padx=7,
            pady=10,
        )
        return progressbar

    def tick(self):
        # get the current local time from the PC
        # if time string has changed, update it
        self.clock.config(text=time.strftime('%y-%m-%d %H:%M:%S'))
        self.progressbar_year["value"] = int(time.strftime('%y'))
        self.progressbar_month["value"] = int(time.strftime('%m'))
        self.progressbar_day["value"] = int(time.strftime('%d'))
        self.progressbar_hours["value"] = int(time.strftime('%H'))
        self.progressbar_minutes["value"] = int(time.strftime('%M'))
        self.progressbar_seconds["value"] = int(time.strftime('%S'))
        # call again
        self.clock.after(500, self.tick)

    # not good programming style, but I'm trying to keep 
    # the example short
    @staticmethod
    def on_quit():
        sys.exit(0)


app = ProgressClock()
app.mainloop()