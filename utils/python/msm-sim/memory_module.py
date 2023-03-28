from utils import Point, status_w

class mem:
    def __init__(self, n_windows, n_buckets, m_segments):
        self.memory = [[(Point(0, 0, 0), status_w(False, True)) for _ in range(2**n_buckets)] for _ in range(n_windows)]
        ## The summation_mem corresponds to the S[k, m] of the paper. The other one corresponds to G[k, m]

        self.g_mem = [[ Point(0, 0, 0) for _ in range(m_segments)] for _ in range(n_windows) ]
        self.sum_mem = [[Point(0, 0, 0) for _ in range(m_segments)] for _ in range(n_windows) ]

        ## Memory parameters
        self.windows = n_windows
        self.buckets_per_window = n_buckets 
        self.segments = m_segments 
        self.size_seg = int((2**self.buckets_per_window) / self.segments)

    def __del__(self):
        print("Class destructor - Bucket")

    def read(self, window, bucket):
        return self.memory[window][bucket]

    def read_g(self, window, segment):
        return self.g_mem[window][segment]

    def read_sum(self, window, segment):
        return self.sum_mem[window][segment]

    def set_busy(self, window, bucket):
        tmp = self.memory[window][bucket - 1]
        self.memory[window][bucket - 1] = (tmp[0], status_w(True, False))

    def set(self, point, window, bucket):
        self.memory[window][bucket - 1] = (point, status_w(False, False))

    def set_g(self, point, window, segment):
        self.g_mem[window][segment] = point

    def set_sum(self, point, window, segment):
        self.sum_mem[window][segment] = point

    def addr_calc(self, it, segment_m):
        return (self.size_seg * (self.segments - segment_m) - it) - 1
