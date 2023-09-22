module CalendarHelper
  # To get calendar's show format start date
  def calendar_start_date(date)
    date.beginning_of_month.beginning_of_week(:sunday)
  end

  # To get calendar's show format end date
  def calendar_end_date(date)
    date.end_of_month.end_of_week(:sunday)
  end

  # To get week start date
  def calendar_week_start_date(date)
    date.beginning_of_week(:sunday)
  end

  # To get week end date
  def calendar_week_end_date(date)
    date.end_of_week(:sunday)
  end

  # To check date is present in show calendar's month
  def check_active_month_in_calendar(check_date,current_date)
    check_date.month == current_date.month
  end

  # To get calendar's show forat total weeks for specified date
  def total_weeks_for_months(date)
    (calendar_start_date(date).to_date..calendar_end_date(date).to_date).count/7
  end

  # To choose months
  def month_options
    12.times.map{ |k| [t("calendar.months.#{k + 1}"), k + 1 ]}
  end

  # fill color for today date
  def fill_color_for_today(date)
    date.today? ? 'bg-success' : ''
  end

  # fill color for saturday or sunday
  def fill_color_for_sat_or_sun(date)
    ( date.saturday? | date.sunday? ) ? 'bg-secondary' : ''
  end
end