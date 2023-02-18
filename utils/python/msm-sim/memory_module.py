from utils import Point, status_w

class mem:
    def __init__(self, n_windows, n_buckets):
        self.buckets = [[(Point(0, 0, 0), status_w(False, True)) for _ in range(2**n_buckets)] for _ in range(n_windows)]

        self.windows = n_windows
        self.buckets_per_window = n_buckets 

    def __del__(self):
        print("Class destructor - Bucket")

    def read(self, window, bucket):
        return self.buckets[window][bucket]

    def set_busy(self, window, bucket):
        tmp = self.buckets[window][bucket - 1]
        self.buckets[window][bucket - 1] = (tmp[0], status_w(True, False))

    def set(self, window, bucket, point):
        self.buckets[window][bucket - 1] = (point, status_w(False, False))
