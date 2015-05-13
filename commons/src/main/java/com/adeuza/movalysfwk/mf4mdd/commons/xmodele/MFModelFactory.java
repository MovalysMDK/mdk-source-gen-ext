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
package com.adeuza.movalysfwk.mf4mdd.commons.xmodele;

import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MPackage;

/**
 * Model factory for Movalys Framework
 * @author lmichenaud
 *
 */
public interface MFModelFactory extends IModelFactory {

	/**
	 * Create dataloader interface
	 */
	/**
	 * @param p_sUmlName uml date
	 * @param p_sName name of dataloader interface
	 * @param p_oPackage package of dataloader interface
	 * @return dataloader interface
	 */
	public MDataLoaderInterface createDataLoaderInterface( String p_sUmlName, String p_sName, MPackage p_oPackage);
	
	
	/**
	 * Create dataloader
	 * @param p_sUmlName uml name
	 * @param p_sName name of dataloader
	 * @param p_oPackage package of dataloader
	 * @param p_oMDataLoaderInterface dataloader interface
	 * @return MDataloader
	 */
	public MDataLoader createDataLoader( String p_sUmlName, String p_sName, MPackage p_oPackage, MDataLoaderInterface p_oMDataLoaderInterface);
}
