import numpy
import pandas

from SourceCode.Generators import Generators
from SourceCode.BinaryFrame import BinaryFrame
from SourceCode.RandomnessTests import RandomnessTester



def construct_binary_frame(data_sets, method, start, end, years_per_block, isamples):
    """
     此函数用于将原始价格数据转化为 BinaryFrame 对象
    :param data_sets: 数据文件
    :param method: 转二元向量的方法
    :param start: 起始日期
    :param end: 终止日期
    :param years_per_block: 使用的时间窗口
    :return: 可用于 RandomnessTester 类的BinaryFrame对象
    """
    data_frame_full = pandas.read_excel(io=data_sets)
    data_frame_full['date'] = pandas.to_datetime(data_frame_full['date'])
    data_frame_full.set_index("date", inplace=True)   
    binary_frame = BinaryFrame(data_frame_full, start, end, years_per_block)
    binary_frame.convert(method, independent_samples=isamples)
    return binary_frame


def run_experiments(data_sets, block_sizes, q_sizes, method, start, end, years_per_block, isamples=False):
    """
    :param data_sets: 数据文件
    :param block_sizes: 块大小
    :param q_sizes: 矩阵大小
    :param start: 起始日期
    :param end: 终止日期
    :param methods: 转二元向量的方法
    :param years_per_block: 使用的时间窗口
    :return: 无
    """
    print("\n")
    print("METHOD =", method.upper())

    length = 256 * (end - start)
    gen = Generators(length)
    prng = gen.numpy_integer()

    all_passed = []
    prng_data = pandas.DataFrame(numpy.array(prng))
    prng_data.columns = ["Mersenne"]
    prng_binary_frame = BinaryFrame(prng_data, start, end, years_per_block)
    prng_binary_frame.convert(method, convert=False, independent_samples=isamples)
    rng_tester = RandomnessTester(prng_binary_frame, False, 00, 00)
    passed = rng_tester.run_test_suite(block_sizes, q_sizes)
    for x in passed:
        all_passed.append(x)

    nrand = numpy.empty(length)
    for i in range(length):
        nrand[i] = (i % 10) / 10
    nrand -= numpy.mean(nrand)
    nrand_data = pandas.DataFrame(numpy.array(nrand))
    nrand_data.columns = ["Deterministic"]
    nrand_binary_frame = BinaryFrame(nrand_data, start, end, years_per_block)
    nrand_binary_frame.convert(method, convert=True, independent_samples=isamples)
    rng_tester = RandomnessTester(nrand_binary_frame, False, 00, 00)
    passed = rng_tester.run_test_suite(block_sizes, q_sizes)
    for x in passed:
        all_passed.append(x)
    my_binary_frame = construct_binary_frame(data_sets, method, start, end, years_per_block, isamples)
    rng_tester = RandomnessTester(my_binary_frame, True, start, end)
    passed = rng_tester.run_test_suite(block_sizes, q_sizes)
    for x in passed:
        all_passed.append(x)

    print("\n")
    return all_passed




if __name__ == '__main__':
    m = "discretize"
    start_year, end_year = 1928, 2018
    least_random_fit = 15
    least_random_interval = 1
    for interval in range(5, 6):
        file_name = 'sp500.xlsx'
        passed = run_experiments(file_name, 64, 4, m, start_year, end_year, interval)
        passed_avg = numpy.array(passed[2::]).mean()
        if passed_avg < least_random_fit:
            least_random_fit = passed_avg
            least_random_interval = interval
    print(least_random_interval, least_random_fit)

