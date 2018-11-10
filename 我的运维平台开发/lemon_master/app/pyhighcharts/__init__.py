class Nestdict(dict):
    """create nested dict"""
    def __missing__(self, key):
        value = self[key] = type(self)()
        return value

class Highchartsdict:
    """ highcharts line,spline,bar,column,area,pie"""
    def create_highcharts_dict(self, chart_type='column', chart_height=350, title='My Title', y_title='yAxis Label',
                               xAxis_categories=['xAxis Data1', 'xAxis Data2', 'xAxis Data3'],
                               series_list=[{"name": 'Label1', "data": [1, 2, 3]},
                                            {"name": 'Label2', "data": [4, 5, 6]}]
                               ):
        chart = {"type": chart_type, "height": chart_height}
        title = {"text": title}
        xAxis = {"categories": xAxis_categories}
        yAxis = {"title": {"text": y_title}}
        series = series_list
        chart_dict = {'chart': chart, 'title': title, 'xAxis': xAxis, 'yAxis': yAxis, 'series': series}
        return chart_dict
        print(chart_dict)

    def create_highcharts_series_list(self,data_source_pymysql_tuple, all_categories_list, all_series_name_list):
        xAxis_categories_list = []
        series_name_list = []
        series_dict = Nestdict()

        for data_info in data_source_pymysql_tuple:
            xAxis_categories_list.append(data_info[0])
            series_dict[data_info[0]][data_info[1]] = data_info[2]
            series_name_list.append(data_info[1])

        have_categories = list(set(xAxis_categories_list))
        not_have_categories = list(set(all_categories_list).difference(set(have_categories)))

        for category in have_categories:
            series_name_keys = list(series_dict[category].keys())
            not_series_name = list(set(all_series_name_list).difference(set(series_name_keys)))
            if len(not_series_name) > 0:
                for series_name in not_series_name:
                    series_dict[category][series_name] = 0

        if len(not_have_categories) > 0:
            for category in not_have_categories:
                for series_name in all_series_name_list:
                    series_dict[category][series_name] = 0

        series_list = []
        for series_name in all_series_name_list:
            series_name_dict = {}
            series_data_list = []
            series_name_dict['name'] = series_name
            for category in all_categories_list:
                series_data_list.append(series_dict[category][series_name])
            series_name_dict['data'] = series_data_list
            series_list.append(series_name_dict)
        print(series_list)
        return series_list
