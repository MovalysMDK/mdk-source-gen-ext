/**
 * Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
package com.adeuza.movalysfwk.mf4mdd.mbandroid.generator;

import com.a2a.adjava.utils.FileTypeUtils;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.commons.generator.AbstractDataLoaderGenerator;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoader;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFDomain;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelDictionary;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelFactory;

/**
 * Dataloader generator
 * @author lmichenaud
 * 
 */
public class DataLoaderGenerator extends AbstractDataLoaderGenerator {
	
	/**
	 * Get filename for dataloader implementation
	 * @param p_oDataLoader dataloader
	 * @param p_oMProject project
	 * @return file name for implementation
	 */
	protected String getImplFileName( MDataLoader p_oDataLoader, XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {
		return FileTypeUtils.computeFilenameForJavaClass(
				p_oMProject.getSourceDir(), p_oDataLoader.getFullName());
	}
	
	/**
	 * Get filename for dataloader interface
	 * @param p_oDataLoader dataloader
	 * @param p_oMProject project
	 * @return file name for interface
	 */
	protected String getInterfaceFileName( MDataLoader p_oDataLoader, XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {
		return FileTypeUtils.computeFilenameForJavaClass(
				p_oMProject.getSourceDir(), p_oDataLoader.getMasterInterface().getFullName());
	}
}
