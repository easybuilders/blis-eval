## `gobff/2020b`

Install (with EasyBuild v4.3.3 or newer):

```shell
eb SciPy-bundle-2020.11-gobff-2020b.eb --robot
```

`numpy` 1.19.4 (Python 3.8.6) tests fail with:

```
=============================================== short test summary info ===============================================
FAILED linalg/tests/test_linalg.py::TestLstsq::test_future_rcond - AssertionError
FAILED random/tests/test_generator_mt19937.py::TestRandomDist::test_multivariate_normal[svd] - AssertionError:
FAILED random/tests/test_generator_mt19937.py::TestRandomDist::test_multivariate_normal[eigh] - AssertionError:
FAILED random/tests/test_random.py::TestRandomDist::test_multivariate_normal - AssertionError:
FAILED random/tests/test_randomstate.py::TestRandomDist::test_multivariate_normal - AssertionError:
========= 5 failed, 10904 passed, 52 skipped, 108 deselected, 21 xfailed, 23 warnings in 88.67s (0:01:28) =============
```

Tested on:

* HPC-UGent `kirlia` (Intel Cascade Lake)
* HPC-UGent `doduo` (AMD Rome)

Same tests fail on both systems.

## `iibff/2020b`

Install (with EasyBuild v4.3.3 or newer):

```shell
eb SciPy-bundle-2020.11-iibff-2020b.eb --robot
```

`numpy` 1.19.4 (Python 3.8.6) tests fail with:

```
=============================================== short test summary info ===============================================
FAILED linalg/tests/test_linalg.py::TestLstsq::test_future_rcond - AssertionError
FAILED linalg/tests/test_linalg.py::TestMatrixPower::test_large_power[dt12] - AssertionError:
FAILED linalg/tests/test_linalg.py::TestMatrixPower::test_large_power[dt15] - AssertionError:
FAILED linalg/tests/test_linalg.py::TestNorm_NonSystematic::test_longdouble_norm - AssertionError:
FAILED random/tests/test_generator_mt19937.py::TestRandomDist::test_multivariate_normal[svd] - AssertionError:
FAILED random/tests/test_generator_mt19937.py::TestRandomDist::test_multivariate_normal[eigh] - AssertionError:
FAILED random/tests/test_random.py::TestRandomDist::test_multivariate_normal - AssertionError:
FAILED random/tests/test_randomstate.py::TestRandomDist::test_multivariate_normal - AssertionError:
========= 8 failed, 10889 passed, 63 skipped, 108 deselected, 21 xfailed, 27 warnings in 123.20s (0:02:03) ============
```

Tested on:

* HPC-UGent `kirlia` (Intel Cascade Lake)
* HPC-UGent `doduo` (AMD Rome)

Same tests fail on both systems.

## Example failed test

(both with `gobff/2020b` and `iibff/2020b`)

```
_________________________________________________________________________________________________________________ TestRandomDist.test_multivariate_normal[svd] _________________________________________________________________________________________________________________

self = <numpy.random.tests.test_generator_mt19937.TestRandomDist object at 0x14eac29cce50>, method = 'svd'

    @pytest.mark.parametrize("method", ["svd", "eigh", "cholesky"])
    def test_multivariate_normal(self, method):
        random = Generator(MT19937(self.seed))
        mean = (.123456789, 10)
        cov = [[1, 0], [0, 1]]
        size = (3, 2)
        actual = random.multivariate_normal(mean, cov, size, method=method)
        desired = np.array([[[-1.747478062846581,  11.25613495182354  ],
                             [-0.9967333370066214, 10.342002097029821 ]],
                            [[ 0.7850019631242964, 11.181113712443013 ],
                             [ 0.8901349653255224,  8.873825399642492 ]],
                            [[ 0.7130260107430003,  9.551628690083056 ],
                             [ 0.7127098726541128, 11.991709234143173 ]]])

>       assert_array_almost_equal(actual, desired, decimal=15)
E       AssertionError:
E       Arrays are not almost equal to 15 decimals
E
E       Mismatched elements: 12 / 12 (100%)
E       Max absolute difference: 3.98341847
E       Max relative difference: 2.2477228
E        x: array([[[ 1.994391640846581,  8.74386504817646 ],
E               [ 1.243646915006621,  9.657997902970179]],
E       ...
E        y: array([[[-1.747478062846581, 11.25613495182354 ],
E               [-0.996733337006621, 10.342002097029821]],
E       ...

actual     = array([[[ 1.99439164,  8.74386505],
        [ 1.24364692,  9.6579979 ]],

       [[-0.53808839,  8.81888629],
        [-0.64322139, 11.1261746 ]],

       [[-0.46611243, 10.44837131],
        [-0.46579629,  8.00829077]]])
cov        = [[1, 0], [0, 1]]
desired    = array([[[-1.74747806, 11.25613495],
        [-0.99673334, 10.3420021 ]],

       [[ 0.78500196, 11.18111371],
        [ 0.89013497,  8.8738254 ]],

       [[ 0.71302601,  9.55162869],
        [ 0.71270987, 11.99170923]]])
mean       = (0.123456789, 10)
method     = 'svd'
random     = Generator(MT19937) at 0x14EAC29CE040
self       = <numpy.random.tests.test_generator_mt19937.TestRandomDist object at 0x14eac29cce50>
size       = (3, 2)
```
