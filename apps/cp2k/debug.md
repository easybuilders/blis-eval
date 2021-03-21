## Debug session for CP2K

debug symbols enabled for CP2K, ScaLAPACK, and libFLAME

```shell
ml CP2K/7.1-gobff-2020b
export OMP_NUM_THREADS=1
cp2k.popt -i Ar-HF-2p-SOC-rcs.inp -o Ar-HF-2p-SOC-rcs.inp.out  # segfaults
gdb cp2k.popt core.xxx
```

## GDB backtrace:

```
(gdb) bt
#0  0x00002b7c32dc8080 in ?? ()
#1  <signal handler called>
#2  0x00002b7c2e1aa349 in zladiv_ (ret_val=0x2b7c2f3651a8, x=<optimized out>, y=0x10bd1370) at src/map/lapack2flamec/f2c/c/zladiv.c:85
#3  0x00002b7c2efbc753 in pzlarfg (n=48, alpha=(0,0.0061106029338021638), iax=48, jax=49, x=..., ix=1, jx=49, descx=..., incx=1, tau=...)
    at /tmp/3775798.master01.hydra.brussel.vsc/ScaLAPACK/2.1.0/gompi-2020b-bf/scalapack-2.1.0/SRC/pzlarfg.f:281
#4  0x00002b7c2efc2f60 in pzlatrd (uplo=..., n=49, nb=17, a=..., ia=1, ja=1, desca=..., d=..., e=..., tau=..., w=..., iw=1, jw=1, descw=..., work=..., _uplo=1)
    at /tmp/3775798.master01.hydra.brussel.vsc/ScaLAPACK/2.1.0/gompi-2020b-bf/scalapack-2.1.0/SRC/pzlatrd.f:310
#5  0x00002b7c2ef84504 in pzhetrd (uplo=..., n=49, a=..., ia=1, ja=1, desca=..., d=..., e=..., tau=..., work=..., lwork=4160, info=0, _uplo=1)
    at /tmp/3775798.master01.hydra.brussel.vsc/ScaLAPACK/2.1.0/gompi-2020b-bf/scalapack-2.1.0/SRC/pzhetrd.f:351
#6  0x00002b7c2ef742d3 in pzheevd (jobz=..., uplo=..., n=49, a=..., ia=1, ja=1, desca=..., w=..., z=..., iz=1, jz=1, descz=..., work=..., lwork=4209, rwork=..., lrwork=7645, iwork=...,
    liwork=353, info=0, _jobz=1, _uplo=1) at /tmp/3775798.master01.hydra.brussel.vsc/ScaLAPACK/2.1.0/gompi-2020b-bf/scalapack-2.1.0/SRC/pzheevd.f:355
#7  0x0000000001ae5df9 in cp_cfm_diag::cp_cfm_heevd (matrix=0x10b65130, eigenvectors=0x10b66250, eigenvalues=...)
    at /tmp/3775798.master01.hydra.brussel.vsc/CP2K/7.1/gobff-2020b/cp2k-7.1/src/fm/cp_cfm_diag.F:123
#8  0x0000000001489f99 in xas_tdp_utils::include_rcs_soc (donor_state=0xc45e9d0, xas_tdp_env=0xc45f250, xas_tdp_control=0xedac2f0, qs_env=0xc23cf60)
    at /tmp/3775798.master01.hydra.brussel.vsc/CP2K/7.1/gobff-2020b/cp2k-7.1/src/xas_tdp_utils.F:3024
#9  0x00000000013714af in xas_tdp_methods::xas_tdp_core (qs_env=0xc23cf60, xas_tdp_section=0xc17ffb0)
    at /tmp/3775798.master01.hydra.brussel.vsc/CP2K/7.1/gobff-2020b/cp2k-7.1/src/xas_tdp_methods.F:454
#10 xas_tdp_methods::xas_tdp (qs_env=0xc23cf60) at /tmp/3775798.master01.hydra.brussel.vsc/CP2K/7.1/gobff-2020b/cp2k-7.1/src/xas_tdp_methods.F:198
#11 0x0000000000f981a8 in qs_energy_utils::qs_energies_properties (qs_env=0xc23cf60) at /tmp/3775798.master01.hydra.brussel.vsc/CP2K/7.1/gobff-2020b/cp2k-7.1/src/qs_energy_utils.F:295
#12 0x000000000081fa2c in qs_energy::qs_energies (qs_env=0xc23cf60, consistent_energies=.FALSE., calc_forces=.FALSE.)
    at /tmp/3775798.master01.hydra.brussel.vsc/CP2K/7.1/gobff-2020b/cp2k-7.1/src/qs_energy.F:111
#13 0x0000000000f17d72 in qs_force::qs_calc_energy_force (qs_env=0xc23cf60, calc_force=.FALSE., consistent_energies=.FALSE., linres=.FALSE.)
    at /tmp/3775798.master01.hydra.brussel.vsc/CP2K/7.1/gobff-2020b/cp2k-7.1/src/qs_force.F:116
#14 0x0000000000b24159 in force_env_methods::force_env_calc_energy_force (force_env=0xc3a55d0, calc_force=.FALSE.,
    consistent_energies=<error reading variable: Cannot access memory at address 0x0>, skip_external_control=<error reading variable: Cannot access memory at address 0x0>,
    eval_energy_forces=<error reading variable: Cannot access memory at address 0x0>, require_consistent_energy_force=<error reading variable: Cannot access memory at address 0x0>,
    linres=<error reading variable: Cannot access memory at address 0x0>, calc_stress_tensor=<error reading variable: Cannot access memory at address 0x0>)
    at /tmp/3775798.master01.hydra.brussel.vsc/CP2K/7.1/gobff-2020b/cp2k-7.1/src/force_env_methods.F:261
#15 0x000000000047cea7 in cp2k_runs::cp2k_run (input_declaration=0x9a090c0, input_file_name=..., output_unit=1, mpi_comm=0, _input_file_name=_input_file_name@entry=1024)
    at /tmp/3775798.master01.hydra.brussel.vsc/CP2K/7.1/gobff-2020b/cp2k-7.1/src/start/cp2k_runs.F:330
#16 0x000000000047eb52 in cp2k_runs::run_input (input_declaration=0x9a090c0, input_file_path=..., output_file_path=...,
    mpi_comm=<error reading variable: Cannot access memory at address 0x0>, _input_file_path=_input_file_path@entry=1024, _output_file_path=140736924232932, _output_file_path@entry=1024)
    at /tmp/3775798.master01.hydra.brussel.vsc/CP2K/7.1/gobff-2020b/cp2k-7.1/src/start/cp2k_runs.F:965
#17 0x000000000046e67f in cp2k () at /tmp/3775798.master01.hydra.brussel.vsc/CP2K/7.1/gobff-2020b/cp2k-7.1/src/start/cp2k.F:296
#18 0x0000000000409b0f in main (argc=<optimized out>, argv=<optimized out>) at /tmp/3775798.master01.hydra.brussel.vsc/CP2K/7.1/gobff-2020b/cp2k-7.1/src/start/cp2k.F:45
#19 0x00002b7c2f6d4555 in __libc_start_main () from /usr/lib64/libc.so.6
#20 0x000000000046d327 in _start ()
```

## GDB backtrace with variables:

```
(gdb) bt full                                                                                                                                                                         [1/84430]
#0  0x00002b7c32dc8080 in ?? ()
No symbol table info available.
#1  <signal handler called>
No symbol table info available.
#2  0x00002b7c2e1aa349 in zladiv_ (ret_val=0x2b7c2f3651a8, x=<optimized out>, y=0x10bd1370) at src/map/lapack2flamec/f2c/c/zladiv.c:85
        d__1 = 0.037104808763777822
        d__2 = 0.0061106029338021638
        d__3 = 4209
        d__4 = 0
        z__1 = {r = 8.8155877319500639e-06, i = 1.4517944722742132e-06}
        zi = 1.4517944722742132e-06
        zr = 8.8155877319500639e-06
#3  0x00002b7c2efbc753 in pzlarfg (n=48, alpha=(0,0.0061106029338021638), iax=48, jax=49, x=..., ix=1, jx=49, descx=..., incx=1, tau=...)
    at /tmp/3775798.master01.hydra.brussel.vsc/ScaLAPACK/2.1.0/gompi-2020b-bf/scalapack-2.1.0/SRC/pzlarfg.f:281
        alphi = 0.0061106029338021638
        alphr = 0
        beta = -0.037104808763777822
        ictxt = 0
        iiax = 48
        indxtau = 49
        ixcol = 0
        ixrow = 0
        j = 2400
        jjax = 49
        knt = 32767
        mycol = 0
        myrow = 0
        npcol = 1
        nprow = 1
        rsafmn = 4.4942328371557898e+307
        safmin = 2.2250738585072014e-308
        xnorm = 0.036598188004079268
        rsrc_ = 7
        nb_ = 6
        n_ = 4
        mb_ = 5
        m_ = 3
        lld_ = 9
        dtype_ = 1
        dlen_ = 9
        ctxt_ = 2
        csrc_ = 8
        block_cyclic_2d = 1
#4  0x00002b7c2efc2f60 in pzlatrd (uplo=..., n=49, nb=17, a=..., ia=1, ja=1, desca=..., d=..., e=..., tau=..., w=..., iw=1, jw=1, descw=..., work=..., _uplo=1)                       [2/84475]
    at /tmp/3775798.master01.hydra.brussel.vsc/ScaLAPACK/2.1.0/gompi-2020b-bf/scalapack-2.1.0/SRC/pzlatrd.f:310
        aii = (9.7311146340325099,0)
        alpha = (2.3341953701112061e-313,6.3814601808751088e-316)
        beta = (0,0.0061106029338021638)
        descd = (1, 0, 1, 49, 1, 32, 0, 0, 1)
        desce = (1, 0, 1, 49, 1, 32, 0, 0, 1)
        descwk = (1, 0, 1, 32, 1, 32, 0, 0, 1)
        i = 49
        iacol = 0
        iarow = 0
        ictxt = 0
        ii = 33
        j = 49
        jj = 33
        jp = 49
        jwk = -226826056
        k = 49
        kw = 17
        mycol = 0
        myrow = 0
        npcol = 1
        nprow = 1
        nq = 49
        rsrc_ = 7
        nb_ = 6
        n_ = 4
        mb_ = 5
        m_ = 3
        lld_ = 9
        dtype_ = 1
        dlen_ = 9
        ctxt_ = 2
        csrc_ = 8
        block_cyclic_2d = 1
#5  0x00002b7c2ef84504 in pzhetrd (uplo=..., n=49, a=..., ia=1, ja=1, desca=..., d=..., e=..., tau=..., work=..., lwork=4160, info=0, _uplo=1)
    at /tmp/3775798.master01.hydra.brussel.vsc/ScaLAPACK/2.1.0/gompi-2020b-bf/scalapack-2.1.0/SRC/pzhetrd.f:351
        colctop = ' '
        descw = (1, 0, 49, 32, 32, 32, 0, 0, 49)
        i = 33
        iacol = 0
        iarow = 0
        icoffa = 0
        ictxt = 0
        idum1 = (85, 1)
        idum2 = (1, 11)
        iinfo = 994101444
        ipw = 1569
        iroffa = 0
        j = 33
        jb = 17
        jx = 2401
        k = 33
        kk = 17
        lquery = .FALSE.
        lwmin = 1600
        mycol = 0
        myrow = 0
        nb = 32
        np = 49
        npcol = 1
        nprow = 1
        nq = 49
        rowctop = ' '
        upper = .TRUE.
        rsrc_ = 7
        nb_ = 6
        n_ = 4
        mb_ = 5
        m_ = 3
        lld_ = 9
        dtype_ = 1
        dlen_ = 9
        ctxt_ = 2
        csrc_ = 8
        block_cyclic_2d = 1
#6  0x00002b7c2ef742d3 in pzheevd (jobz=..., uplo=..., n=49, a=..., ia=1, ja=1, desca=..., w=..., z=..., iz=1, jz=1, descz=..., work=..., lwork=4209, rwork=..., lrwork=7645, iwork=.[42/84593]
    liwork=353, info=0, _jobz=1, _uplo=1) at /tmp/3775798.master01.hydra.brussel.vsc/ScaLAPACK/2.1.0/gompi-2020b-bf/scalapack-2.1.0/SRC/pzheevd.f:355
        anrm = 9.9101751170825914
        bignum = 9.9792015476735991e+291
        csrc_a = 0
        descrz = (2089936867, 1063544629, 468634781, 999370195, -423273266, 1063594004, -1178956134, 996522408, 1010460730)
        eps = 2.2204460492503131e-16
        i = 11132
        iacol = 0
        iarow = 0
        icoffa = 0
        ictxt = 0
        idum1 = (85, 1)
        idum2 = (2, 14)
        iinfo = 0
        iiz = 1
        indd = 50
        inde = 1
        inde2 = 99
        indrwork = 148
        indtau = 1
        indwork = 50
        indz = 11132
        ipr = -1289298046
        ipz = 1058349188
        iroffa = 0
        iroffz = 0
        iscale = 0
        izcol = 0
        izrow = 0
        j = 32767
        jjz = 1
        ldr = 11132
        ldz = 799512416
        liwmin = 353
        llrwork = 7498
        llwork = 4160
        lower = .FALSE.
        lquery = .FALSE.
        lrwmin = 7645
        lwmin = 4209
        mb_a = 32
        mycol = 0
        myrow = 0
        nb = 32
        nb_a = 32
        nn = 49
        np0 = 49
        npcol = 1
        nprow = 1
        nq = 49
        nq0 = 49
        offset = 0
        rmax = 8.187737150746412e+76
        rmin = 1.0010415475915505e-146
        rsrc_a = 0
        safmin = 2.2250738585072014e-308
        sigma = 7.95192748707077e-19
        smlnum = 1.0020841800044864e-292
        rsrc_ = 7
        nb_ = 6
        n_ = 4
        mb_ = 5
        m_ = 3
        lld_ = 9
        dtype_ = 1
        dlen_ = 9
        ctxt_ = 2
        csrc_ = 8
        block_cyclic_2d = 1
#7  0x0000000001ae5df9 in cp_cfm_diag::cp_cfm_heevd (matrix=0x10b65130, eigenvectors=0x10b66250, eigenvalues=...)
    at /tmp/3775798.master01.hydra.brussel.vsc/CP2K/7.1/gobff-2020b/cp2k-7.1/src/fm/cp_cfm_diag.F:123
        descm = (1, 0, 49, 49, 32, 32, 0, 0, 49)
        descv = (1, 0, 49, 49, 32, 32, 0, 0, 49)
        handle = 495
        info = 0
        iwork = <error reading variable iwork (access outside bounds of object referenced via synthetic pointer)>
        liwork = 353
        lrwork = 7645
        lwork = 4209
        m = (
../.././gdb/gdbtypes.h:526: internal-error: LONGEST dynamic_prop::const_val() const: Assertion 'm_kind == PROP_CONST' failed.
```
