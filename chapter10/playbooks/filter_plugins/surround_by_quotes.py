''' https://stackoverflow.com/a/68610557/571517 '''


class FilterModule():
    ''' FilterModule class must have a method named filters '''
    @staticmethod
    def surround_by_quotes(a_list):
        ''' implements surround_by_quotes for each list element '''
        return ['"%s"' % an_element for an_element in a_list]

    def filters(self):
        ''' returns a dictionary that maps filter names to
        callables implementing the filter '''
        return {'surround_by_quotes': self.surround_by_quotes}

