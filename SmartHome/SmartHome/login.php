<?php
session_start();
$title = "Login";
?>

<!DOCTYPE html>
<html lang="en">

<?php require('Partials/head.php')?>

<body class="bg-gradient-primary">
	<div class="container">
		<!-- Outer Row -->
		<div class="row justify-content-center">
			<div class="col-md-8 col-lg-6 col-10">
				<div class="card o-hidden border-0 shadow-lg my-5">
					<div class="card-body p-0">
						<!-- Nested Row within Card Body -->
						<div class="row">
							<div class="col-md-12">
								<div class="p-5">
									<div class="text-center">
										<h1 class="h4 text-gray-900 mb-4">Login!</h1>
									</div>
									<form class="user" method="POST" action="auth_process.php">
                                        <div class="form-group">
                                            <input type="text" class="form-control form-control-user" id="username" aria-describedby="username" placeholder="Username" autocomplete="off" name="username">
                                        </div>
										<div class="form-group">
											<input type="password" class="form-control form-control-user" id="exampleInputPassword" name="password" placeholder="Password" autocomplete="off">
										</div>
										<div class="row d-flex justify-content-center align-items-center">
										<div class="col-4">
										<button type="submit" class="btn btn-primary btn-user btn-block">
											Login
										</button>
										</div>
										</div>
										

									</form>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<?php require('Partials/script.php')?>
</body>
</html>
